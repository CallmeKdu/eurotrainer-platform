
// Ponte (Bridge) entre o curso SCORM e o Flutter
window.API = {
  data: {
    "cmi.core.lesson_status": "not attempted",
    "cmi.suspend_data": "",
    "cmi.core.score.raw": ""
  },
  LMSInitialize: function(param) { return "true"; },
  LMSGetValue: function(element) { return this.data[element] || ""; },
  LMSSetValue: function(element, value) {
    this.data[element] = value;
    return "true";
  },
  LMSCommit: function(param) {
    // Quando o curso dispara o Commit, passamos os dados para a função do Flutter!
    if (window.onScormCommit) {
      window.onScormCommit(this.data["cmi.core.lesson_status"], this.data["cmi.core.score.raw"]);
    }
    return "true";
  },
  LMSFinish: function(param) { return "true"; },
  LMSGetLastError: function() { return "0"; },
  LMSGetErrorString: function(errCode) { return "No error"; },
  LMSGetDiagnostic: function(errCode) { return "No error diagnostic"; }
};

// Adicionamos compatibilidade com SCORM 2004 também (caso você exporte diferente no futuro)
window.API_1484_11 = window.API;
