// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart_pad.summarize;

import 'package:crypto/crypto.dart';

import '../services/dartservices.dart';

/// Instances of this class take string input of dart code as well as an analysis result,
/// and output a text description ofthe code's size, packages, and other useful information.
class Summarizer {
  _SummarizeToken storage;

  bool resultsPresent;
  MD5 encryptor;
  static Map<String, List<int>> cuttoffs = {
    'size': [8, 30, 100],
    'errors': [1,5,10]
  };
  static Map<String, List<String>> categories = {
    /// This [size] [codeQuantifier] contains [error] errors and warnings.
    'size-2': ['gigantic', 'Jupiterian sized', 'immense', 
      'massive', 'enormous', 'huge', 'epic', 'humongous'],
    'size-1': ['decently sized', 'exceptional', 'awesome', 
      'amazing', 'visionary', 'legendary'],
    'size-0': ['itty-bitty', 'miniature', 'tiny', 'pint-sized'],
    'compiledQuantifier': ['DART program', 'pad', ''],
    'failedQuantifier': ['assemblage of characters', 'series of strings', 'grouping of letters'],
    'errorCount-2':['many', 'a motherload of', 'copious amounts of', 'unholy quantities of'],
    'errorCount-1':['some', 'a few', 'sparse amounts of', 'very few instances of'],
    'errorCount-0':['zero', 'no', 'a void of', '0.0000', '0'],
  };
  
  Summarizer(String input, [AnalysisResults analysis]) {
    if (input == null) throw new ArgumentError("Input can't be null.");
    resultsPresent = !(analysis == null);
    encryptor = new MD5();
    encryptor.add(input.codeUnits);
    storage = new _SummarizeToken(input, analysis);
  }
  
  String _wordSelector(String category) {
    if (categories.containsKey(category)) {
      
    }
    else {
      
    }
  }
  
  String returnAsSimpleSummary() {
      if (resultsPresent) {
        String summary = "Summary:";
        summary +='This ${storage.linesCode} lines of code.\n';
        if (storage.errorPresent) summary += 'Errors are present.\n';
        if (storage.errorPresent) summary += 'Warnings are present.\n';
        summary += '${storage.features}\n\n';
        summary += '${storage.packageCount} Package Imports: ${storage.packageImports}.\n';
        summary += '${storage.resolvedCount} Resolved Imports: ${storage.resolvedImports}.\n';
        summary += 'List of ${storage.errorCount} Errors:\n';
        for (AnalysisIssue issue in storage.errors) {
          summary += '- ${_condenseIssue(issue)}\n';
        }
        summary += "```";
        return summary;
      }
      else {
        String summary = "``` \n-- Summary (Under Development) --\n";
        summary +='${storage.linesCode} lines of code.\n';
        return summary;
      }
    }
  
  String returnAsVerboseSummary() {
    if (resultsPresent) {
      String summary = "Summary:";
      summary +='There are ${storage.linesCode} lines of code.\n';
      if (storage.errorPresent) summary += 'Errors are present.\n';
      if (storage.errorPresent) summary += 'Warnings are present.\n';
      summary += '${storage.features}\n\n';
      summary += '${storage.packageCount} Package Imports: ${storage.packageImports}.\n';
      summary += '${storage.resolvedCount} Resolved Imports: ${storage.resolvedImports}.\n';
      summary += 'List of ${storage.errorCount} Errors:\n';
      for (AnalysisIssue issue in storage.errors) {
        summary += '- ${_condenseIssue(issue)}\n';
      }
      summary += "```";
      return summary;
    }
    else {
      String summary = "``` \n-- Summary (Under Development) --\n";
      summary +='${storage.linesCode} lines of code.\n';
      return summary;
    }
  }
  
  String returnAsMarkDown() {
    if (resultsPresent) {
      String summary = "``` \n-- Summary (Under Development) --\n\n";
      summary +='${storage.linesCode} lines of code.\n\n';
      if (storage.errorPresent) summary += 'Errors are present.\n\n';
      if (storage.errorPresent) summary += 'Warnings are present.\n\n';
      summary += '${storage.features} \n\n';
      summary += '${storage.packageCount} Package Imports: ${storage.packageImports}.\n\n';
      summary += '${storage.resolvedCount} Resolved Imports: ${storage.resolvedImports}.\n\n';
      summary += 'List of ${storage.errorCount} Errors:\n\n';
      for (AnalysisIssue issue in storage.errors) {
        summary += '- ${_condenseIssue(issue)}\n';
      }
      summary += "```";
      return summary;
    }
    else {
      String summary = "``` \n-- Summary (Under Development) --\n\n";
      summary +='${storage.linesCode} lines of code.\n\n';
      return summary;
    }
  }
  
  String _condenseIssue(AnalysisIssue issue) {
    return '''${issue.kind.toUpperCase()} | ${issue.message}\n
  Source at ${issue.sourceName}.\n
  Located at line: ${issue.line}.\n
  ''';
    }
}

class _SummarizeToken {
  int linesCode;
  int packageCount;
  int resolvedCount;
  int errorCount;
  
  bool errorPresent;
  bool warningPresent;
  
  String features;
  
  List<String> packageImports;
  List<String> resolvedImports;
  
  List<AnalysisIssue> errors;
  
  _SummarizeToken (String input, [AnalysisResults analysis]) {
    linesCode = _linesOfCode(input);
    if (analysis != null) {
      errorPresent = analysis.issues.any((issue) => issue.kind == 'error');
      warningPresent = analysis.issues.any((issue) => issue.kind == 'warning');
      features = _languageFeatures(analysis);
      packageCount= analysis.packageImports.length;
      resolvedCount = analysis.resolvedImports.length;
      packageImports = analysis.packageImports;
      resolvedImports = analysis.resolvedImports;
      errors = analysis.issues;
      errorCount = errors.length;
    }
  }
  
  String _languageFeatures(AnalysisResults input) {
    // TODO: Add language features.
    return "Language features under construction.";
  }
   
  int _linesOfCode(String input) {
    return input.split('\n').length;
  }
}
