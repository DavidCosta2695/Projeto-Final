//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cloud_firestore/cloud_firestore_plugin_c_api.h>
#include <file_selector_windows/file_selector_windows.h>
<<<<<<< HEAD
#include <firebase_auth/firebase_auth_plugin_c_api.h>
=======
>>>>>>> 208bd2a85c021932134f233c1b8002d16498a927
#include <firebase_core/firebase_core_plugin_c_api.h>
#include <firebase_storage/firebase_storage_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  CloudFirestorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CloudFirestorePluginCApi"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
<<<<<<< HEAD
  FirebaseAuthPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseAuthPluginCApi"));
=======
>>>>>>> 208bd2a85c021932134f233c1b8002d16498a927
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  FirebaseStoragePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseStoragePluginCApi"));
}
