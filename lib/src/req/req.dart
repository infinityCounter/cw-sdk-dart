library req;

import 'dart:convert' as convert show jsonDecode;

import 'package:http/http.dart' as http show Client;

import '../common/common.dart' as common;

part 'assets.dart';

const assetsEndpoint = cwAPIDomain + '/assets';
const cwAPIDomain = 'https://api.cryptowat.ch';
const exchangesEndpoint = cwAPIDomain + '/exchanges';
const marketsEndpoint = cwAPIDomain + '/markets';
const pairsEndpoint = cwAPIDomain + '/pairs';

var client = http.Client();
