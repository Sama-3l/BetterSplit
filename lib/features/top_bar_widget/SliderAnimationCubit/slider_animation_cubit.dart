import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'slider_animation_state.dart';

class SliderAnimationCubit extends Cubit<SliderAnimationState> {
  SliderAnimationCubit() : super(SliderAnimationInitial(offsetX: 0));

  update(offsetX) => emit(SliderAnimationUpdate(offsetX: offsetX));
}
