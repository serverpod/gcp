import 'package:serverpod/serverpod.dart';

import 'package:gcp_server/src/web/routes/root.dart';
// import 'package:serverpod_cloud_storage_gcp/serverpod_cloud_storage_gcp.dart'
// as gcp;

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // If you are using any future calls, they need to be registered here.
  // pod.registerFutureCall(ExampleFutureCall(), 'exampleFutureCall');

  // Setup a default page at the web root.
  // pod.webServer.addRoute(RouteRoot(), '/');
  // pod.webServer.addRoute(RouteRoot(), '/index.html');
  // // Serve all files in the /static directory.
  // pod.webServer.addRoute(
  //   RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
  //   '/*',
  // );

  // pod.addCloudStorage(gcp.GoogleCloudStorage(
  //   serverpod: pod,
  //   storageId: 'public',
  //   public: true,
  //   region: 'us',
  //   bucket: 'storage.examplepod.com',
  //   publicHost: 'storage.examplepod.com',
  // ));

  // pod.addCloudStorage(gcp.GoogleCloudStorage(
  //   serverpod: pod,
  //   storageId: 'private',
  //   public: false,
  //   region: 'us',
  //   bucket: 'private-storage.examplepod.com',
  // ));

  // Configure storage

  // Start the server.
  await pod.start();
}
