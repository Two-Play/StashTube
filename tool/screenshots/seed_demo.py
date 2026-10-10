#!/usr/bin/env python3
"""Set up a demo Stash for the README screenshots and fill it with metadata."""

# The demo library is made of clips from Blender's open movies (CC BY), cut by
# demo_server.sh into /data in the container. This script talks to the demo
# server's GraphQL API only (no packages needed):
#
#     python3 tool/screenshots/seed_demo.py http://localhost:9999
#
# It runs the setup, scans and generates (covers, sprites, previews, markers),
# then adds studios, performers, tags, titles, ratings, markers, a group, a
# gallery and some watch history. Running it again only updates.

import base64
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

URL = (sys.argv[1] if len(sys.argv) > 1 else 'http://localhost:9999').rstrip('/') + '/graphql'
if urllib.parse.urlparse(URL).scheme not in ('http', 'https'):
    sys.exit(f'Not an http(s) address: {URL}')
# demo_server.sh's work dir, with covers/ and portraits/ (optional).
WORK = sys.argv[2] if len(sys.argv) > 2 else None


def image_data(path):
    """A JPEG as a data URI, which Stash takes as an image; None if missing."""
    if not WORK or not os.path.exists(path):
        return None
    with open(path, 'rb') as file:
        return 'data:image/jpeg;base64,' + base64.b64encode(file.read()).decode()


def gql(query, **variables):
    body = json.dumps({'query': query, 'variables': variables}).encode()
    request = urllib.request.Request(URL, body, {'Content-Type': 'application/json'})
    try:
        # Only http(s), checked where URL is set: the demo server.
        with urllib.request.urlopen(request, timeout=60) as response:  # nosec B310 # nosemgrep
            data = json.load(response)
    except urllib.error.HTTPError as e:
        # Stash answers invalid queries with 422 and the errors in the body.
        raise RuntimeError(f'{e.code}: {e.read().decode()}\n{query}') from None
    if data.get('errors'):
        raise RuntimeError(json.dumps(data['errors'], indent=2))
    return data['data']


def wait_for_server():
    for _ in range(120):
        try:
            return gql('{ systemStatus { status } }')['systemStatus']['status']
        except Exception:  # noqa: BLE001 - not up yet
            time.sleep(1)
    raise RuntimeError('Stash did not start')


def wait_for_jobs():
    time.sleep(2)
    while gql('{ jobQueue { id } }')['jobQueue']:
        time.sleep(2)


# File name (without extension) -> metadata. Dates are the films' releases.
SCENES = {
    'tos-the-bridge': dict(title='The Bridge', studio='Tears of Steel', performers=['Celia', 'Thom'],
                           tags=['Sci-Fi', 'Drama'], date='2012-09-26', rating=90),
    'tos-old-memories': dict(title='Old Memories', studio='Tears of Steel', performers=['Celia', 'Thom'],
                             tags=['Sci-Fi', 'Drama'], date='2012-09-26', rating=80),
    'tos-the-robots': dict(title='The Robots Arrive', studio='Tears of Steel', performers=['Barley', 'Celia'],
                           tags=['Sci-Fi', 'Action', 'Robots'], date='2012-09-26', rating=100),
    'tos-last-stand': dict(title='Last Stand', studio='Tears of Steel', performers=['Barley', 'Thom'],
                           tags=['Sci-Fi', 'Action', 'Robots'], date='2012-09-26', rating=80),
    'tos-ending': dict(title='A Second Chance', studio='Tears of Steel', performers=['Celia', 'Thom'],
                       tags=['Sci-Fi', 'Drama'], date='2012-09-26', rating=60),
    'caminandes-gran-dillama': dict(title='Gran Dillama', studio='Caminandes', performers=['Koro'],
                                    tags=['Animation', 'Comedy'], date='2013-11-22', rating=100),
    'sintel-trailer': dict(title='The Search for Scales', studio='Sintel', performers=['Sintel'],
                           tags=['Animation', 'Fantasy', 'Adventure'], date='2010-09-27', rating=80),
    'big-buck-bunny-trailer': dict(title='A Bunny Story', studio='Big Buck Bunny', performers=['Big Buck Bunny'],
                                   tags=['Animation', 'Comedy'], date='2008-05-30', rating=60),
    # Portrait clips for the shorts.
    'short-celia-runs': dict(title='Run, Celia', studio='Tears of Steel', performers=['Celia'],
                             tags=['Sci-Fi', 'Action', 'Short'], date='2012-09-26', rating=80),
    'short-robot': dict(title='Robot Eye', studio='Tears of Steel', performers=['Barley'],
                        tags=['Sci-Fi', 'Robots', 'Short'], date='2012-09-26', rating=60),
    'short-koro': dict(title='Llama Drama', studio='Caminandes', performers=['Koro'],
                       tags=['Animation', 'Comedy', 'Short'], date='2013-11-22', rating=100),
    'short-sintel': dict(title='Dragon Flight', studio='Sintel', performers=['Sintel'],
                         tags=['Animation', 'Fantasy', 'Short'], date='2010-09-27', rating=80),
    'short-bunny': dict(title='Bunny Wakes Up', studio='Big Buck Bunny', performers=['Big Buck Bunny'],
                        tags=['Animation', 'Comedy', 'Short'], date='2008-05-30', rating=60),
}

STUDIO_PARENT = 'Blender Studio'
STUDIOS = ['Tears of Steel', 'Caminandes', 'Sintel', 'Big Buck Bunny']

# Seconds into a scene -> (title, primary tag).
MARKERS = {
    'tos-the-bridge': [(12, 'On the bridge', 'Drama'), (48, 'The argument', 'Drama')],
    'tos-the-robots': [(5, 'First contact', 'Robots'), (40, 'Under fire', 'Action')],
    'tos-last-stand': [(10, 'The plan', 'Action'), (55, 'Last stand', 'Robots')],
    'caminandes-gran-dillama': [(20, 'The fence', 'Comedy'), (90, 'Breakthrough', 'Comedy')],
    'sintel-trailer': [(15, 'The dragon', 'Fantasy')],
}

# Watched scenes: (resume position in seconds or 0, plays).
HISTORY = {'tos-the-robots': (45, 2), 'caminandes-gran-dillama': (0, 3), 'sintel-trailer': (20, 1), 'tos-the-bridge': (0, 1)}


def ensure(kind, name, create, extra=None):
    """The id of the studio/performer/tag [name], created if missing."""
    found = gql(f'query($q: String!) {{ find{kind}s(filter: {{q: $q, per_page: 50}}) {{ {kind.lower()}s {{ id name }} }} }}',
                q=name)[f'find{kind}s'][f'{kind.lower()}s']
    for item in found:
        if item['name'] == name:
            return item['id']
    return gql(f'mutation($input: {create}Input!) {{ {create[0].lower() + create[1:]}(input: $input) {{ id }} }}',
               input={'name': name, **(extra or {})})[create[0].lower() + create[1:]]['id']


def setup_and_scan():
    if wait_for_server() == 'SETUP':
        gql('mutation($input: SetupInput!) { setup(input: $input) }', input={
            'configLocation': '', 'databaseFile': '', 'generatedLocation': '', 'cacheLocation': '',
            'blobsLocation': '', 'storeBlobsInDatabase': False,
            'stashes': [{'path': '/data', 'excludeVideo': False, 'excludeImage': False}],
        })
        wait_for_server()
    print('scanning')
    gql('mutation { metadataScan(input: {scanGenerateCovers: true, scanGeneratePhashes: false, '
        'scanGenerateThumbnails: true}) }')
    wait_for_jobs()


def add_people_and_tags():
    """Studios (with their parent), performers with portraits, and tags."""
    parent = ensure('Studio', STUDIO_PARENT, 'StudioCreate')
    studios = {name: ensure('Studio', name, 'StudioCreate', {'parent_id': parent}) for name in STUDIOS}
    studios[STUDIO_PARENT] = parent
    performers = {name: ensure('Performer', name, 'PerformerCreate')
                  for scene in SCENES.values() for name in scene['performers']}
    for name, performer_id in performers.items():
        portrait = image_data(os.path.join(WORK or '', 'portraits', f'{name}.jpg'))
        if portrait:
            gql('mutation($input: PerformerUpdateInput!) { performerUpdate(input: $input) { id } }',
                input={'id': performer_id, 'image': portrait})
    tags = {name: ensure('Tag', name, 'TagCreate') for scene in SCENES.values() for name in scene['tags']}
    return studios, performers, tags


def describe_scenes(studios, performers, tags):
    """Titles, people, tags, ratings and covers; returns the scene ids by file name."""
    scenes = gql('{ findScenes(filter: {per_page: -1}) { scenes { id files { basename } } } }')['findScenes']['scenes']
    ids = {}
    for scene in scenes:
        key = scene['files'][0]['basename'].rsplit('.', 1)[0]
        meta = SCENES.get(key)
        if meta is None:
            continue
        ids[key] = scene['id']
        update = {
            'id': scene['id'], 'title': meta['title'], 'date': meta['date'], 'rating100': meta['rating'],
            'studio_id': studios[meta['studio']], 'performer_ids': [performers[p] for p in meta['performers']],
            'tag_ids': [tags[t] for t in meta['tags']], 'organized': True,
            'details': 'From the Blender open movie project, licensed under CC BY.',
        }
        cover = image_data(os.path.join(WORK or '', 'covers', f'{key}.jpg'))
        if cover:
            update['cover_image'] = cover
        gql('mutation($input: SceneUpdateInput!) { sceneUpdate(input: $input) { id } }', input=update)
    return ids


def add_markers(ids, tags):
    if gql('{ findSceneMarkers { count } }')['findSceneMarkers']['count']:
        return
    for key, markers in MARKERS.items():
        for seconds, title, tag in markers:
            gql('mutation($input: SceneMarkerCreateInput!) { sceneMarkerCreate(input: $input) { id } }', input={
                'scene_id': ids[key], 'seconds': seconds, 'title': title, 'primary_tag_id': tags[tag]})


def reset_history(ids):
    """Reset the watch history to the same start."""
    # Also after a screenshot run played scenes: the app saves the position back.
    for scene_id in ids.values():
        gql('mutation($id: ID!) { sceneResetPlayCount(id: $id) }', id=scene_id)
        gql('mutation($id: ID!) { sceneResetActivity(id: $id, reset_resume: true, reset_duration: true) }', id=scene_id)
    for key, (resume, count) in HISTORY.items():
        for _ in range(count):
            gql('mutation($id: ID!) { sceneAddPlay(id: $id) { count } }', id=ids[key])
        if resume:
            gql('mutation($id: ID!, $t: Float) { sceneSaveActivity(id: $id, resume_time: $t, playDuration: 30) }',
                id=ids[key], t=float(resume))


def add_group(ids, studios):
    if gql('{ findGroups { count } }')['findGroups']['count']:
        return
    group = gql('mutation($input: GroupCreateInput!) { groupCreate(input: $input) { id } }', input={
        'name': 'Tears of Steel', 'studio_id': studios['Tears of Steel'], 'date': '2012-09-26',
        'synopsis': 'All parts of the film, in order.'})['groupCreate']['id']
    parts = ['tos-the-bridge', 'tos-old-memories', 'tos-the-robots', 'tos-last-stand', 'tos-ending']
    for index, key in enumerate(parts, start=1):
        gql('mutation($input: SceneUpdateInput!) { sceneUpdate(input: $input) { id } }', input={
            'id': ids[key], 'groups': [{'group_id': group, 'scene_index': index}]})


def add_gallery(studios):
    if gql('{ findGalleries { count } }')['findGalleries']['count']:
        return
    images = gql('{ findImages(filter: {per_page: -1}) { images { id } } }')['findImages']['images']
    if not images:
        return
    gallery = gql('mutation($input: GalleryCreateInput!) { galleryCreate(input: $input) { id } }', input={
        'title': 'Stills', 'studio_id': studios[STUDIO_PARENT], 'date': '2012-09-26'})['galleryCreate']['id']
    gql('mutation($input: GalleryAddInput!) { addGalleryImages(input: $input) }',
        input={'gallery_id': gallery, 'image_ids': [i['id'] for i in images]})


def generate():
    print('generating')
    gql('mutation { metadataGenerate(input: {covers: true, sprites: true, previews: true, imagePreviews: true, '
        'markers: true, markerImagePreviews: true, markerScreenshots: true, imageThumbnails: true}) }')
    wait_for_jobs()


def main():
    setup_and_scan()
    studios, performers, tags = add_people_and_tags()
    ids = describe_scenes(studios, performers, tags)
    add_markers(ids, tags)
    reset_history(ids)
    add_group(ids, studios)
    add_gallery(studios)
    generate()
    print(f'done: {len(ids)} scenes')


if __name__ == '__main__':
    main()
