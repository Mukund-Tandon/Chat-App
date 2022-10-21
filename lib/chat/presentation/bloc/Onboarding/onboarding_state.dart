part of 'onboarding_cubit.dart';

@immutable
abstract class OnboardingState extends Equatable {}

class OnboardingInitial extends OnboardingState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loading extends OnboardingState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnboardingSuccess extends OnboardingState {
  final UserEntity user;
  OnboardingSuccess(this.user);
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
