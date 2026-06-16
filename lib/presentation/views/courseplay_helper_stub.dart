void registerScormCallback(String trainingId, void Function(String status, double score) onCommit) {
  // No-op on VM platforms
}

void registerIframeViewFactory(String iframeId, String scormUrl) {
  // No-op on VM platforms
}

void cleanupScormCallback() {
  // No-op on VM platforms
}
