import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/usecase/usecase.dart';
import '../../../domain/entities/analysis_data_entity.dart';
import '../../../domain/usecases/get_analysis_data_usecase.dart';

part 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final GetAnalysisDataUseCase _getAnalysisDataUseCase;

  AnalysisCubit({
    required GetAnalysisDataUseCase getAnalysisDataUseCase,
  })  : _getAnalysisDataUseCase = getAnalysisDataUseCase,
        super(AnalysisInitial());

  Future<void> loadAnalysisData() async {
    emit(AnalysisLoading());
    final result = await _getAnalysisDataUseCase(const NoParams());
    
    result.fold(
      (failure) {
        if (failure.message.contains('Access Denied')) {
          emit(AnalysisForbidden());
        } else {
          emit(AnalysisError(failure.message));
        }
      },
      (data) => emit(AnalysisLoaded(data)),
    );
  }
}
