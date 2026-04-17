import '../models/analysis_data_model.dart';

abstract class AnalysisDataSource {
  Future<AnalysisDataModel> fetchAnalysisData();
}

class AnalysisMockDataSourceImpl implements AnalysisDataSource {
  @override
  Future<AnalysisDataModel> fetchAnalysisData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return const AnalysisDataModel(
      occupancyPercent: 0.75,
      occupiedCount: 450,
      freeCount: 150,
      totalCapacity: 600,
      carsParkedTotal: 1240,
      carsParkedChange: 0.12,
      carsLeftTotal: 850,
      carsLeftChange: 0.05,
      onlineCameras: 24,
      offlineCameras: 2,
    );
  }
}
