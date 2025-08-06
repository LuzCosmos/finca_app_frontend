part of 'package:finca_app_frontend/core/blocs/locale/locale_bloc.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends LocaleEvent {
  final Language selectedLanguage;

  const ChangeLanguage(this.selectedLanguage);

  @override
  List<Object> get props => [selectedLanguage];
}
