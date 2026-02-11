import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/utils/language.dart';

part 'package:finca_app_frontend/core/blocs/locale/locale_event.dart';
part 'package:finca_app_frontend/core/blocs/locale/locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleInitial()) {
    on<ChangeLanguage>(_onChangeLanguage);
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<LocaleState> emit) {
    emit(LocaleChanged(language: event.selectedLanguage));
  }
}
