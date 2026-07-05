import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../manager/find_car_cubit/find_car_cubit.dart';
import '../manager/find_car_cubit/find_car_state.dart';
import '../widgets/car_card.dart';
import '../../../profile/presentation/manager/saved_cars_cubit/saved_cars_cubit.dart';
import '../../../profile/presentation/manager/saved_cars_cubit/saved_cars_state.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';

class FindCarView extends StatelessWidget {
  const FindCarView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Find My Car",
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: -0.36,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: const SafeArea(
        child: _FindCarBody(),
      ),
    );
  }
}

class _FindCarBody extends StatefulWidget {
  const _FindCarBody();

  @override
  State<_FindCarBody> createState() => _FindCarBodyState();
}

class _FindCarBodyState extends State<_FindCarBody> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<FindCarCubit>();
    if (cubit.floorsList.isEmpty || cubit.sectionsList.isEmpty) {
      cubit.loadFilters();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSavedCarsPopup() {
    final savedCarsCubit = context.read<SavedCarsCubit>();
    final state = savedCarsCubit.state;

    if (state is! SavedCarsLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Loading saved cars, please try again...',
            style: GoogleFonts.spaceGrotesk(),
          ),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      savedCarsCubit.loadSavedCars();
      return;
    }

    final cars = state.cars;
    if (cars.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'No Saved Cars',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'You do not have any saved cars. Please add cars in your profile page.',
            style: GoogleFonts.spaceGrotesk(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xff00A24F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (cars.length == 1) {
      final car = cars.first;
      _selectCarForSearch(car);
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final listBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
        final plateColor = isDark ? Colors.white70 : const Color(0xFF64748B);

        return Container(
          decoration: BoxDecoration(
            color: listBgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white30 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Saved Car',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    final isNoPlate = car.plateNumber.startsWith('UNKNOWN');
                    final displayPlate = isNoPlate ? 'No Plate' : car.plateNumber;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xff00A24F).withOpacity(0.1),
                          child: const Icon(Icons.directions_car,
                              color: Color(0xff00A24F)),
                        ),
                        title: Text(
                          car.model,
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                        subtitle: Text(
                          '$displayPlate - ${car.color}',
                          style: GoogleFonts.spaceGrotesk(
                            color: plateColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          _selectCarForSearch(car);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectCarForSearch(dynamic car) {
    final isUnknown = car.plateNumber.startsWith('UNKNOWN');
    final plate = isUnknown ? '' : car.plateNumber;

    setState(() {
      _searchController.text = plate;
    });

    context.read<FindCarCubit>().searchWithSavedCar(
          plateNumber: plate,
          brand: car.model,
          color: car.color.toLowerCase().trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final iconColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final hintColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final closeBgColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final closeIconColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final headingColor = isDark ? Colors.white70 : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: sl<ApiClient>().isGuest
          ? null
          : FloatingActionButton.extended(
              onPressed: _showSavedCarsPopup,
              backgroundColor: const Color(0xff00A24F),
              icon: const Icon(Icons.bookmarks_outlined, color: Colors.white),
              label: Text(
                "Search by Saved Cars",
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: searchBgColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(9999),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.search, color: iconColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.spaceGrotesk(color: textColor, fontSize: 16),
                    onChanged: (query) => context.read<FindCarCubit>().searchCars(query),
                    decoration: InputDecoration(
                      hintText: "Enter plate number",
                      hintStyle: GoogleFonts.spaceGrotesk(
                        color: hintColor,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    context.read<FindCarCubit>().clearSearch();
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: closeBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 20, color: closeIconColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Filters Row
        BlocBuilder<FindCarCubit, FindCarState>(
          builder: (context, state) {
            final cubit = context.read<FindCarCubit>();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown<String?>(
                          context: context,
                          value: cubit.floor,
                          hint: "All Floors",
                          icon: Icons.layers_outlined,
                          items: [
                            const DropdownMenuItem(value: null, child: Text("All Floors")),
                            ...cubit.floorsList.map(
                              (floorVal) => DropdownMenuItem(
                                value: floorVal,
                                child: Text(floorVal),
                              ),
                            ),
                            if (cubit.floor != null && !cubit.floorsList.contains(cubit.floor))
                              DropdownMenuItem(
                                value: cubit.floor,
                                child: Text(cubit.floor!),
                              ),
                          ],
                          onChanged: (val) {
                            cubit.updateFloor(val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterDropdown<String?>(
                          context: context,
                          value: cubit.section,
                          hint: "All Sections",
                          icon: Icons.grid_view_outlined,
                          items: [
                            const DropdownMenuItem(value: null, child: Text("All Sections")),
                            ...cubit.sectionsList.map(
                              (sectionVal) => DropdownMenuItem(
                                value: sectionVal,
                                child: Text(sectionVal.length == 1 ? "Sec $sectionVal" : sectionVal),
                              ),
                            ),
                            if (cubit.section != null && !cubit.sectionsList.contains(cubit.section))
                              DropdownMenuItem(
                                value: cubit.section,
                                child: Text(cubit.section!.length == 1 ? "Sec ${cubit.section!}" : cubit.section!),
                              ),
                          ],
                          onChanged: (val) {
                            cubit.updateSection(val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final brandList = [
                              'Ashok Leyland', 'Audi', 'Bentley', 'Bharat Benz', 'BMW', 
                              'Eicher Motors', 'Ford', 'Honda', 'Hyundai', 'Jaguar', 
                              'KIA', 'Land Rover', 'Mahindra', 'Maruti Suzuki', 'Mercedes', 
                              'MG Motors', 'Nissan', 'Renault', 'Rolls Royce', 'Skoda', 
                              'Swaraj Mazda', 'Tata', 'Toyota', 'Volkswagen', 'Volvo', 
                              'Chevrolet', 'Citreon', 'Fiat', 'Jeep'
                            ];
                            return _buildFilterDropdown<String?>(
                              context: context,
                              value: cubit.brand,
                              hint: "All Brands",
                              icon: Icons.directions_car_outlined,
                              items: [
                                const DropdownMenuItem(value: null, child: Text("All Brands")),
                                ...brandList.map(
                                  (brandVal) => DropdownMenuItem(
                                    value: brandVal,
                                    child: Text(brandVal),
                                  ),
                                ),
                                if (cubit.brand != null && !brandList.contains(cubit.brand))
                                  DropdownMenuItem(
                                    value: cubit.brand,
                                    child: Text(cubit.brand!),
                                  ),
                              ],
                              onChanged: (val) {
                                cubit.updateBrand(val);
                              },
                            );
                          }
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final colorList = [
                              "black", "blue", "brown", "green", "grey", "orange", "red", "silver", "white", "yellow"
                            ];
                            return _buildFilterDropdown<String?>(
                              context: context,
                              value: cubit.color,
                              hint: "All Colors",
                              icon: Icons.color_lens_outlined,
                              items: [
                                const DropdownMenuItem(value: null, child: Text("All Colors")),
                                ...colorList.map(
                                  (colorVal) => DropdownMenuItem(
                                    value: colorVal,
                                    child: Text(colorVal[0].toUpperCase() + colorVal.substring(1)),
                                  ),
                                ),
                                if (cubit.color != null && !colorList.contains(cubit.color))
                                  DropdownMenuItem(
                                    value: cubit.color,
                                    child: Text(cubit.color![0].toUpperCase() + cubit.color!.substring(1)),
                                  ),
                              ],
                              onChanged: (val) {
                                cubit.updateColor(val);
                              },
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        // Heading "RESULTS"
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 12.0),
          child: Text(
            "RESULTS",
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.7,
              color: headingColor,
            ),
          ),
        ),
        // Car List
        Expanded(
          child: BlocBuilder<FindCarCubit, FindCarState>(
            builder: (context, state) {
              if (state is FindCarInitial) {
                final isDarkInit = Theme.of(context).brightness == Brightness.dark;
                final initHeadingColor = isDarkInit ? Colors.white : const Color(0xFF475569);
                final initSubColor = isDarkInit ? Colors.white70 : const Color(0xFF64748B);
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_outlined,
                          size: 64,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            "Search by Plate number or Car attributes",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: initHeadingColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            "Enter a plate number, color, vehicle type to locate the vehicle's parking spot.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              color: initSubColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is FindCarLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff00A24F),
                  ),
                );
              }
              if (state is FindCarError) {
                return Center(child: Text(state.message));
              }
              if (state is FindCarLoaded) {
                if (state.cars.isEmpty) {
                  return const Center(child: Text("No cars found"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: state.cars.length,
                  itemBuilder: (context, index) {
                    return CarCard(car: state.cars[index]);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFilterDropdown<T>({
    required BuildContext context,
    required T value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final iconColor = isDark ? Colors.white70 : const Color(0xFF64748B);

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                items: items,
                onChanged: onChanged,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: iconColor,
                  size: 20,
                ),
                style: GoogleFonts.spaceGrotesk(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
