// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;


/// Utility class for network-related operations.
class NetworkUtility {
  // Sends an HTTP GET request to the specified [uri].
  ///
  // Returns the response body as a [String] if the request is successful (status code 200).
  /// If an error occurs or the request fails, it returns `null`.
  ///
  // - [uri]: The [Uri] of the target URL.
  // - [headers]: Optional headers for the request.
  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
       // Perform an HTTP GET request
      final response = await http.get(uri, headers: headers);
      // Check if the request was successful
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      // Print the error message to the console if an exception occurs
      print(e.toString());
    }
    // Return null if the request fails or the status code is not 200
    return null;
  }
}