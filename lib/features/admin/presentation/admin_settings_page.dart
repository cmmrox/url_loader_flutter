import 'package:flutter/material.dart';
import '../../../core/services/url_config_service.dart';
import '../../../core/constants/app_constants.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final UrlConfigService _urlConfigService = UrlConfigService.instance;
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    await _urlConfigService.loadBaseUrl();
    setState(() {
      _currentUrl = _urlConfigService.baseUrl;
      _urlController.text = _currentUrl;
    });
  }

  Future<void> _saveUrl() async {
    final url = _urlController.text.trim();
    
    if (url.isEmpty) {
      setState(() {
        _errorMessage = 'URL cannot be empty';
      });
      return;
    }

    if (!_urlConfigService.isValidUrl(url)) {
      setState(() {
        _errorMessage = 'Invalid URL format. Please enter a valid http:// or https:// URL';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await _urlConfigService.saveBaseUrl(url);
    
    setState(() {
      _isLoading = false;
      if (success) {
        _currentUrl = url;
        _errorMessage = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('URL saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        });
      } else {
        _errorMessage = 'Failed to save URL';
      }
    });
  }

  Future<void> _resetToDefault() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _urlConfigService.resetToDefault();
    await _loadCurrentUrl();
    
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL reset to default'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current URL',
                      style: TextStyle(
                        fontSize: AppConstants.subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      _currentUrl,
                      style: TextStyle(
                        fontSize: AppConstants.titleFontSize,
                        color: Colors.blue[700],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Base URL Configuration',
                      style: TextStyle(
                        fontSize: AppConstants.subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: 'Enter Base URL',
                        hintText: 'http://example.com:3000',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.link),
                        errorText: _errorMessage,
                      ),
                      keyboardType: TextInputType.url,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _saveUrl,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.save),
                            label: const Text('Save URL'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMedium),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _resetToDefault,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(
                      child: Text(
                        'Changes will take effect immediately after saving.',
                        style: TextStyle(
                          fontSize: AppConstants.subtitleFontSize,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


