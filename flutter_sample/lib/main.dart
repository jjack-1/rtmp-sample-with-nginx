// main.dart

import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiveStreamPage(),
    );
  }
}

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({super.key});

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  // ✅ [수정] 컨트롤러는 나중에 초기화되므로 late 키워드를 유지합니다.
  late final ApiVideoLiveStreamController _controller;
  bool _isStreaming = false;

  // ✅ [추가] 카메라가 준비되었는지 확인하는 새로운 상태 변수입니다.
  bool _isCameraReady = false;

  String streamUrl = "rtmp://192.168.0.31:1935/live";
  String streamKey = "test-stream";

  @override
  void initState() {
    super.initState();
    // ✅ [수정] initState에서는 더 이상 카메라를 자동으로 초기화하지 않습니다.
  }

  /// ✅ [신규] '카메라 준비' 버튼을 눌렀을 때 실행될 메서드입니다.
  Future<void> _prepareCamera() async {
    // 1. 권한 요청
    await _requestPermissions();

    // 2. 컨트롤러 설정 및 초기화
    await _initController();

    // 3. 카메라 준비가 완료되었음을 상태에 반영하여 UI를 갱신합니다.
    if (mounted) {
      setState(() {
        _isCameraReady = true;
      });
    }
  }

  /// ✅ 카메라 및 마이크 권한 요청 (기존과 동일)
  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }

  /// ✅ 컨트롤러 설정 및 생성 (기존과 거의 동일)
  Future<void> _initController() async {
    final videoConfig = VideoConfig(
      resolution: Resolution.RESOLUTION_1080,
      bitrate: 5000000,
    );
    final audioConfig = AudioConfig(
      bitrate: 128000,
      sampleRate: SampleRate.kHz_44_1,
      channel: Channel.stereo,
    );

    _controller = ApiVideoLiveStreamController(
      initialAudioConfig: audioConfig,
      initialVideoConfig: videoConfig,
      initialCameraPosition: CameraPosition.back,
      onConnectionSuccess: () => print("✅ RTMP 서버 연결 성공"),
      onConnectionFailed: (error) => print("❌ RTMP 연결 실패: $error"),
      onDisconnection: () => print("🔌 방송 연결이 끊어졌습니다"),
      onError: (err) => print("🚨 에러 발생: $err"),
    );

    try {
      // 컨트롤러 초기화
      await _controller.initialize();
    } catch (e) {
      print("🚨 컨트롤러 초기화 실패: $e");
    }
    // ✅ [수정] 초기화 후 setState는 _prepareCamera 메서드에서 관리합니다.
  }

  /// ✅ 스트리밍 상태 토글 (기존과 동일)
  Future<void> _toggleStream() async {
    if (_isStreaming) {
      await _controller.stopStreaming();
    } else {
      await _controller.startStreaming(streamKey: streamKey, url: streamUrl);
    }
    setState(() {
      _isStreaming = !_isStreaming;
    });
  }

  @override
  void dispose() {
    // ✅ [추가] 카메라가 준비된 경우에만 컨트롤러를 dispose하도록 안전장치를 추가합니다.
    if (_isCameraReady) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live RTMP Streaming")),
      body: Stack(
        children: [
          // ✅ [수정] 카메라 준비 상태에 따라 미리보기 또는 검은 박스를 보여줍니다.
          Center(
            child: _isCameraReady
                ? ApiVideoCameraPreview(controller: _controller)
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        "카메라 준비 버튼을 눌러주세요",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          ),

          // ✅ [수정] 하단 버튼들을 Row 위젯으로 재구성합니다.
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. 카메라 준비 버튼
                ElevatedButton(
                  // 카메라가 준비되면 버튼은 비활성화됩니다.
                  onPressed: _isCameraReady ? null : _prepareCamera,
                  child: const Text("카메라 준비"),
                ),

                // 2. 방송 시작/중지 버튼
                ElevatedButton(
                  // 카메라가 준비되어야만 버튼이 활성화됩니다.
                  onPressed: _isCameraReady ? _toggleStream : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isStreaming ? Colors.red : null,
                  ),
                  child: Text(_isStreaming ? "방송 중지" : "방송 시작"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
