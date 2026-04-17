import '../models/parking_overview_model.dart';

abstract class ParkingOverviewDataSource {
  Future<ParkingOverviewModel> fetchParkingOverview();
}
