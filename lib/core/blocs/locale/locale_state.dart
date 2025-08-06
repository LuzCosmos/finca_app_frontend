part of 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';

sealed class LocaleState extends Equatable {
  final Language selectedLanguage;
  const LocaleState({Language? language})
    : selectedLanguage = language ?? Language.spanish;

  @override
  List<Object> get props => [selectedLanguage];
}

final class LocaleInitial extends LocaleState {}

final class LocaleChanged extends LocaleState {
  const LocaleChanged({super.language});
}
