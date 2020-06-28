import 'package:dartin/dartin.dart';
import 'package:dio/dio.dart';

import '../helper/constants.dart';
import '../helper/shared_preferences.dart';
import '../model/repository.dart';
import '../viewmodel/home_provide.dart';

const testScope = DartInScope('test');

final viewModelModule = Module([
  factory<HomeProvide>(({params}) => HomeProvide(params.get(0), get())),
])
  ..withScope(testScope, [
    ///other scope
//  factory<HomeProvide>(({params}) => HomeProvide(params.get(0), get<GithubRepo>())),
  ]);

final repoModule = Module([
  factory<GithubRepo>(({params}) => GithubRepo(get(), get())),
]);

final remoteModule = Module([
  factory<GithubService>(({params}) => GithubService()),
]);

final localModule = Module([
  single<SpUtil>(({params}) => spUtil),
]);

final appModule = [viewModelModule, repoModule, remoteModule, localModule];

class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    final token = spUtil.getString(KEY_TOKEN);
    options.headers
        .update("Authorization", (_) => token, ifAbsent: () => token);
    return super.onRequest(options);
  }
}

final dio = Dio()
  ..options = BaseOptions(
      baseUrl: 'https://api.github.com/',
      connectTimeout: 30,
      receiveTimeout: 30)
  ..interceptors.add(AuthInterceptor())
  ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

SpUtil spUtil;

init() async {
  spUtil = await SpUtil.getInstance();
  // DartIn start
  startDartIn(appModule);
}
