import 'package:fitnessapp/providers/userdata.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:linkable/linkable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/providers/user_provider.dart';

class DataModel {
  final String title;
  final String description;
  final String imageUrl;
  final String details;
  final String youtubeUrl;
  final int reps;
  final int set;
  final int time;

  DataModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.details,
    required this.youtubeUrl,
    this.reps = 0,
    this.set = 0,
    this.time = 0,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      details: json['details'] ?? '',
      youtubeUrl: json['youtubeUrl'] ?? '',
      reps: json['reps'] ?? 0,
      set: json['set'] ?? 0,
      time: json['time'] ?? 0,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 1;
  int _lastPage = 1;
  List<DataModel> _data = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  SharedPreferences? logindata;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);
    fetchPage(_currentPage);
    Provider.of<UserData>(context, listen: false).fetchUserData();
  }

  Future<void> fetchPage(int page, [String? keyword]) async {
    try {
      String? token = Provider.of<UserData>(context, listen: false).token;
      final response = await Dio().get(
          'https://sbit3j-service.onrender.com/v1/global/workout-library',
          queryParameters: {
            'page': page,
            'keyword': keyword,
          },
          options: Options(
            headers: {
              "Authorization": "Bearer $token"
            },
          ));
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> data = responseData['data'];
      final Map<String, dynamic> meta = responseData['meta'];
      setState(() {
        if (page == 1) {
          _data = data.map((item) => DataModel.fromJson(item)).toList();
        } else {
          _data.addAll(data.map((item) => DataModel.fromJson(item)).toList());
        }
        _currentPage = meta['current_page'];
        _lastPage = meta['last_page'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  void _onSearchChanged() {
    fetchPage(1, _searchController.text);
  }

  void loadMoreData() {
    if (_currentPage < _lastPage) {
      fetchPage(_currentPage + 1, _searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for workouts',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[800],
                    ),
                    onChanged: (value) {
                      fetchPage(1, value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  onPressed: () => fetchPage(1, _searchController.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // add this line
              itemCount: _data.length + 1,
              itemBuilder: (context, index) {
                if (index == _data.length) {
                  return TextButton(
                    onPressed: loadMoreData,
                    child: const Text('Load more'),
                  );
                }
                final DataModel itemData = _data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(data: itemData),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(5),
                    elevation: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Image.network(
                            itemData.imageUrl.isNotEmpty ? itemData.imageUrl :
                            'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemData.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  itemData.description,
                                  textAlign: TextAlign.justify,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final DataModel data;

  DetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        backgroundColor: const Color(0xff004AAD),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  data.imageUrl.isNotEmpty ? data.imageUrl :
                  'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                data.title.isNotEmpty ? data.title :
                'Not Available',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(
                    Icons.repeat,
                    size: 16.0,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${data.reps} reps',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.fitness_center,
                    size: 16.0,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${data.set} sets',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Icon(
                    Icons.timer,
                    size: 16.0,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${data.time} time',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  if (data.youtubeUrl != null) {
                    launch(data.youtubeUrl);
                  } else{
                    launch('https://www.youtube.com/');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.video_library,
                        size: 24.0,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Watch Video',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                data.description.isNotEmpty ? data.description :
                'Not Available',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

