
 String extractUrl(String text) {
    // Define a regular expression for extracting a single URL
    RegExp urlRegex = RegExp(
      r"(http|https):\/\/[a-zA-Z0-9\-_]+(\.[a-zA-Z0-9\-_]+)+([a-zA-Z0-9\-\.,@?^=%&:\/~\+#]*[a-zA-Z0-9\-\@?^=%&\/~\+#])?",
      caseSensitive: false,
      multiLine: false,
    );

    // Use the regular expression to find the first match in the text
    RegExpMatch? match = urlRegex.firstMatch(text);

    // Extract the URL from the match
    String? url = match?.group(0);

    return url ?? ""; // Return an empty string if no URL is found
  }


  bool isURL(String text) {
    // Define a regular expression for a simple URL pattern
    RegExp urlRegex = RegExp(
      r"^(http|https):\/\/[a-zA-Z0-9\-_]+(\.[a-zA-Z0-9\-_]+)+([a-zA-Z0-9\-\.,@?^=%&:\/~\+#]*[a-zA-Z0-9\-\@?^=%&\/~\+#])?$",
      caseSensitive: false,
      multiLine: false,
    );

    // Use the regular expression to check if the text matches the URL pattern
    return urlRegex.hasMatch(text);
  }
