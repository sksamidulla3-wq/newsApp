import 'package:flutter/material.dart';
import 'package:newsapp/model/api_model.dart';

class SecondScreen extends StatelessWidget {
  ContentModel contentModel;

  SecondScreen({super.key, required this.contentModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Second Screen")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            contentModel.urlToImage != null &&
                    contentModel.urlToImage!.isNotEmpty
                ? SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: Image.network(
                      contentModel.urlToImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.image_not_supported),
            Text(
              contentModel.title ?? "No Title",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              contentModel.description ?? "No Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "Author: ${contentModel.author ?? "No Author"}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "Published At: ${contentModel.publishedAt ?? "No Published At"}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "Source: ${contentModel.source?.name ?? "No Source"}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
