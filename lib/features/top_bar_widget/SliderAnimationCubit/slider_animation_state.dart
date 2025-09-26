part of 'slider_animation_cubit.dart';

@immutable
sealed class SliderAnimationState {
  final double offsetX;

  const SliderAnimationState({required this.offsetX});
}

final class SliderAnimationInitial extends SliderAnimationState {
  const SliderAnimationInitial({required super.offsetX});
}

final class SliderAnimationUpdate extends SliderAnimationState {
  const SliderAnimationUpdate({required super.offsetX});
}
