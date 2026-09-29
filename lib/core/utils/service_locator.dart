import 'package:get_it/get_it.dart';
import 'package:templet/core/networking/dio_helper.dart';
import 'package:templet/core/utils/storge_helper.dart';
import 'package:templet/features/auth_screen/cubit/auth_cubit.dart';
import 'package:templet/features/auth_screen/repo/auth_repo.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  DioHelper dio = DioHelper();
  //dio Helper
  sl.registerSingleton<DioHelper>(dio);
  sl.registerLazySingleton(() => StorgeHelper());

  sl.registerLazySingleton(() => AuthRepo(sl<DioHelper>()));


  // cubits
  sl.registerFactory(() => AuthCubit(sl<AuthRepo>()));
}
