import 'package:flutter/painting.dart';

/// How much [BoxFit.cover] may crop of a picture before it is shown whole
/// ([BoxFit.contain]) instead.
const double kMaxPictureCrop = 0.3;

/// Cover a box of [boxAspect] (width / height) with a picture of [aspect]
/// when that crops at most [kMaxPictureCrop] of it, else show it whole: a
/// portrait video fills a phone but not a landscape tablet or a 16:9
/// thumbnail, where covering zoomed it to the full width.
BoxFit pictureFit(double? aspect, double boxAspect) {
  if (aspect == null || aspect <= 0 || boxAspect <= 0 || !boxAspect.isFinite) return BoxFit.contain;
  final shown = aspect < boxAspect ? aspect / boxAspect : boxAspect / aspect;
  return 1 - shown <= kMaxPictureCrop ? BoxFit.cover : BoxFit.contain;
}
