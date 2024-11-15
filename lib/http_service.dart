import 'dart:convert';  // For json decoding
import 'package:http/http.dart' as http;  // HTTP package

// Function to fetch posts from the REST API using the HTTP package
Future<List<dynamic>> fetchPostsUsingHttp() async {
  // Define the API endpoint
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  // Send GET request with custom headers (e.g., Authorization)
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',  // Ensure it's in JSON format
      'Authorization': 'Bearer your_api_key',  // Add your API key if required
    },
  );

  // Check if the request was successful (status code 200)
  if (response.statusCode == 200) {
    // Parse the JSON response and return the data
    return json.decode(response.body);
  } else {
    // If the request failed, throw an exception
    throw Exception('Failed to load posts');
  }
}
