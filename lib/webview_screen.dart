import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  final String webUrl = "https://requisition.ratanproducts.com";

  // স্টেট ম্যানেজমেন্ট ভেরিয়েবল
  bool isLoading = true;
  String currentTitle = "Loading...";

  // অ্যাডমোব ব্যানার
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initBannerAd();

    // প্রফেশনাল পুল-টু-রিফ্রেশ কনফিগারেশন
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.deepPurple,
        backgroundColor: Colors.white,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
            urlRequest: URLRequest(url: await webViewController?.getUrl()),
          );
        }
      },
    );
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // টেস্ট আইডি
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isBannerAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
    );
    _bannerAd?.load();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await [Permission.storage, Permission.photos].request();
    }
  }

  Future<void> _downloadFile(String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        Directory? downloadsDirectory =
            await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
        final dlManager = DownloadManager();
        final fileName = url.split('/').last.split('?').first;
        final savePath = "${downloadsDirectory.path}/$fileName";

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Downloading: $fileName...')));
        await dlManager.addDownload(url, savePath);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved to Downloads Folder!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download Failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        // ব্রাউজারে ব্যাক হিস্ট্রি থাকলে অ্যাপের ভেতর ব্যাক করবে, নাহলে হোম পেজে ফিরবে
        if (await webViewController?.canGoBack() ?? false) {
          webViewController?.goBack();
        } else {
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        // ==================== ১. অসাম মডার্ন কাস্টম টপ বার ====================
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 70, // ব্যাক বাটনের জন্য স্পেস ফিক্সড করা
          leading: Padding(
            padding: const EdgeInsets.only(left: 14.0, top: 8.0, bottom: 8.0),
            child: InkWell(
              onTap: () async {
                if (await webViewController?.canGoBack() ?? false) {
                  webViewController?.goBack();
                } else {
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50, // হালকা সফট ব্যাকগ্রাউন্ড
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 14, // ছোট এবং শার্প আইকন
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          title: Text(
            currentTitle,
            style: const TextStyle(
              fontSize: 13, // ছোট এবং প্রফেশনাল ফন্ট সাইজ
              fontWeight: FontWeight.w700, // বোল্ড লুক
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey.withOpacity(
                0.15,
              ), // টপ বারের নিচে খুব হালকা বর্ডার লাইন
              height: 1.0,
            ),
          ),
        ),

        // ==================== ২. বডি এরিয়া (ওয়েবভিউ ও কাস্টম প্রি-লোডার) ====================
        body: SafeArea(
          child: Stack(
            children: [
              // অরিজিনাল অপ্টিমাইজড ওয়েবভিউ কন্টেনার
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(webUrl)),
                initialSettings: InAppWebViewSettings(
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  useOnDownloadStart: true,
                  javaScriptEnabled: true,
                  domStorageEnabled: true, // ক্যাশ পারফরম্যান্স বুস্টের জন্য
                  databaseEnabled: true,
                ),
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) =>
                    webViewController = controller,
                onLoadStart: (controller, url) {
                  setState(() {
                    isLoading = true;
                    currentTitle = "Connecting System...";
                  });
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController?.endRefreshing();

                  // ওয়েবসাইট থেকে লাইভ পেজ টাইটেল তুলে এনে অ্যাপের টপ বারে সেট করা
                  String? webTitle = await controller.getTitle();
                  setState(() {
                    isLoading = false;
                    currentTitle = (webTitle != null && webTitle.isNotEmpty)
                        ? webTitle
                        : "Requisition Panel";
                  });
                },
                onProgressChanged: (controller, progressPercentage) {
                  if (progressPercentage == 100) {
                    pullToRefreshController?.endRefreshing();
                  }
                  // প্রোগ্রেস অনুযায়ী টাইটেল আপডেট (অপশনাল, দেখতে চমৎকার লাগে)
                  if (isLoading) {
                    setState(() {
                      currentTitle = "Loading ($progressPercentage%)";
                    });
                  }
                },
                onDownloadStartRequest:
                    (controller, downloadStartRequest) async {
                      await _downloadFile(downloadStartRequest.url.toString());
                    },
              ),

              // প্রফেশনাল ফুল-স্ক্রিন প্রি-লোডার (যা পেজ লোড হলে ফেড-আউট হয়ে যাবে)
              if (isLoading)
                Container(
                  color: Colors.white, // পেজ লোডের সময় ব্যাকগ্রাউন্ড সাদা রাখবে
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5, // প্রিমিয়াম থিকনেস স্লট
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.deepPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Securing Dashboard Connection...',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // অ্যাডমোব নিচে শো করার কন্টেনার
        bottomNavigationBar: _isBannerAdLoaded
            ? SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
