// https://performance-partners.apple.com/search-api

import 'dart:convert';
import 'package:http/http.dart' as http;

enum Media {
  movie,
  podcast,
  music,
  musicVideo,
  audiobook,
  shortFilm,
  tvShow,
  software,
  ebook,
  all,
}

/// List of all ISO 3166-1 alpha-2 country codes.
///
/// Source: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
class CountryCode {
  static String get andorra => 'AD';
  static String get unitedArabEmirates => 'AE';
  static String get afghanistan => 'AF';
  static String get antiguaAndBarbuda => 'AG';
  static String get anguilla => 'AI';
  static String get albania => 'AL';
  static String get armenia => 'AM';
  static String get angola => 'AO';
  static String get antarctica => 'AQ';
  static String get argentina => 'AR';
  static String get americanSamoa => 'AS';
  static String get austria => 'AT';
  static String get australia => 'AU';
  static String get aruba => 'AW';
  static String get alandIslands => 'AX';
  static String get azerbaijan => 'AZ';
  static String get bosniaAndHerzegovina => 'BA';
  static String get barbados => 'BB';
  static String get bangladesh => 'BD';
  static String get belgium => 'BE';
  static String get burkinaFaso => 'BF';
  static String get bulgaria => 'BG';
  static String get bahrain => 'BH';
  static String get burundi => 'BI';
  static String get benin => 'BJ';
  static String get saintBarthelemy => 'BL';
  static String get bermuda => 'BM';
  static String get bruneiDarussalam => 'BN';
  static String get bolivia => 'BO';
  static String get bonaireSintEustatiusAndSaba => 'BQ';
  static String get brazil => 'BR';
  static String get bahamas => 'BS';
  static String get bhutan => 'BT';
  static String get bouvetIsland => 'BV';
  static String get botswana => 'BW';
  static String get belarus => 'BY';
  static String get belize => 'BZ';
  static String get canada => 'CA';
  static String get cocosIslands => 'CC';
  static String get congoKinshasa => 'CD';
  static String get centralAfricanRepublic => 'CF';
  static String get congoBrazzaville => 'CG';
  static String get switzerland => 'CH';
  static String get coteDIvoire => 'CI';
  static String get cookIslands => 'CK';
  static String get chile => 'CL';
  static String get cameroon => 'CM';
  static String get china => 'CN';
  static String get colombia => 'CO';
  static String get costaRica => 'CR';
  static String get cuba => 'CU';
  static String get capeVerde => 'CV';
  static String get curacao => 'CW';
  static String get christmasIsland => 'CX';
  static String get cyprus => 'CY';
  static String get czechRepublic => 'CZ';
  static String get germany => 'DE';
  static String get djibouti => 'DJ';
  static String get denmark => 'DK';
  static String get dominica => 'DM';
  static String get dominicanRepublic => 'DO';
  static String get algeria => 'DZ';
  static String get ecuador => 'EC';
  static String get estonia => 'EE';
  static String get egypt => 'EG';
  static String get westernSahara => 'EH';
  static String get eritrea => 'ER';
  static String get spain => 'ES';
  static String get ethiopia => 'ET';
  static String get finland => 'FI';
  static String get fiji => 'FJ';
  static String get falklandIslands => 'FK';
  static String get micronesia => 'FM';
  static String get faroeIslands => 'FO';
  static String get france => 'FR';
  static String get gabon => 'GA';
  static String get unitedKingdom => 'GB';
  static String get grenada => 'GD';
  static String get georgia => 'GE';
  static String get frenchGuiana => 'GF';
  static String get guernsey => 'GG';
  static String get ghana => 'GH';
  static String get gibraltar => 'GI';
  static String get greenland => 'GL';
  static String get gambia => 'GM';
  static String get guinea => 'GN';
  static String get guadeloupe => 'GP';
  static String get equatorialGuinea => 'GQ';
  static String get greece => 'GR';
  static String get southGeorgiaAndTheSouthSandwichIslands => 'GS';
  static String get guatemala => 'GT';
  static String get guam => 'GU';
  static String get guineaBissau => 'GW';
  static String get guyana => 'GY';
  static String get hongKong => 'HK';
  static String get heardAndMcDonaldIslands => 'HM';
  static String get honduras => 'HN';
  static String get croatia => 'HR';
  static String get haiti => 'HT';
  static String get hungary => 'HU';
  static String get indonesia => 'ID';
  static String get ireland => 'IE';
  static String get israel => 'IL';
  static String get isleOfMan => 'IM';
  static String get india => 'IN';
  static String get britishIndianOceanTerritory => 'IO';
  static String get iraq => 'IQ';
  static String get iran => 'IR';
  static String get iceland => 'IS';
  static String get italy => 'IT';
  static String get jersey => 'JE';
  static String get jamaica => 'JM';
  static String get jordan => 'JO';
  static String get japan => 'JP';
  static String get kenya => 'KE';
  static String get kyrgyzstan => 'KG';
  static String get cambodia => 'KH';
  static String get kiribati => 'KI';
  static String get comoros => 'KM';
  static String get saintKittsAndNevis => 'KN';
  static String get northKorea => 'KP';
  static String get southKorea => 'KR';
  static String get kuwait => 'KW';
  static String get caymanIslands => 'KY';
  static String get kazakhstan => 'KZ';
  static String get laos => 'LA';
  static String get lebanon => 'LB';
  static String get saintLucia => 'LC';
  static String get liechtenstein => 'LI';
  static String get sriLanka => 'LK';
  static String get liberia => 'LR';
  static String get lesotho => 'LS';
  static String get lithuania => 'LT';
  static String get luxembourg => 'LU';
  static String get latvia => 'LV';
  static String get libya => 'LY';
  static String get morocco => 'MA';
  static String get monaco => 'MC';
  static String get moldova => 'MD';
  static String get montenegro => 'ME';
  static String get saintMartin => 'MF';
  static String get madagascar => 'MG';
  static String get marshallIslands => 'MH';
  static String get macedonia => 'MK';
  static String get mali => 'ML';
  static String get myanmar => 'MM';
  static String get mongolia => 'MN';
  static String get macao => 'MO';
  static String get northernMarianaIslands => 'MP';
  static String get martinique => 'MQ';
  static String get mauritania => 'MR';
  static String get montserrat => 'MS';
  static String get malta => 'MT';
  static String get mauritius => 'MU';
  static String get maldives => 'MV';
  static String get malawi => 'MW';
  static String get mexico => 'MX';
  static String get malaysia => 'MY';
  static String get mozambique => 'MZ';
  static String get namibia => 'NA';
  static String get newCaledonia => 'NC';
  static String get niger => 'NE';
  static String get norfolkIsland => 'NF';
  static String get nigeria => 'NG';
  static String get nicaragua => 'NI';
  static String get netherlands => 'NL';
  static String get norway => 'NO';
  static String get nepal => 'NP';
  static String get nauru => 'NR';
  static String get niue => 'NU';
  static String get newZealand => 'NZ';
  static String get oman => 'OM';
  static String get panama => 'PA';
  static String get peru => 'PE';
  static String get frenchPolynesia => 'PF';
  static String get papuaNewGuinea => 'PG';
  static String get philippines => 'PH';
  static String get pakistan => 'PK';
  static String get poland => 'PL';
  static String get saintPierreAndMiquelon => 'PM';
  static String get pitcairn => 'PN';
  static String get puertoRico => 'PR';
  static String get palestinianTerritory => 'PS';
  static String get portugal => 'PT';
  static String get palau => 'PW';
  static String get paraguay => 'PY';
  static String get qatar => 'QA';
  static String get reunion => 'RE';
  static String get romania => 'RO';
  static String get serbia => 'RS';
  static String get russianFederation => 'RU';
  static String get rwanda => 'RW';
  static String get saudiArabia => 'SA';
  static String get solomonIslands => 'SB';
  static String get seychelles => 'SC';
  static String get sudan => 'SD';
  static String get sweden => 'SE';
  static String get singapore => 'SG';
  static String get saintHelena => 'SH';
  static String get slovenia => 'SI';
  static String get svalbardAndJanMayenIslands => 'SJ';
  static String get slovakia => 'SK';
  static String get sierraLeone => 'SL';
  static String get sanMarino => 'SM';
  static String get senegal => 'SN';
  static String get somalia => 'SO';
  static String get suriname => 'SR';
  static String get southSudan => 'SS';
  static String get saoTomeAndPrincipe => 'ST';
  static String get elSalvador => 'SV';
  static String get sintMaarten => 'SX';
  static String get syrianArabRepublic => 'SY';
  static String get swaziland => 'SZ';
  static String get turksAndCaicosIslands => 'TC';
  static String get chad => 'TD';
  static String get frenchSouthernTerritories => 'TF';
  static String get togo => 'TG';
  static String get thailand => 'TH';
  static String get tajikistan => 'TJ';
  static String get tokelau => 'TK';
  static String get timorLeste => 'TL';
  static String get turkmenistan => 'TM';
  static String get tunisia => 'TN';
  static String get tonga => 'TO';
  static String get turkey => 'TR';
  static String get trinidadAndTobago => 'TT';
  static String get tuvalu => 'TV';
  static String get taiwan => 'TW';
  static String get tanzania => 'TZ';
  static String get ukraine => 'UA';
  static String get uganda => 'UG';
  static String get unitedStatesMinorOutlyingIslands => 'UM';
  static String get unitedStates => 'US';
  static String get uruguay => 'UY';
  static String get uzbekistan => 'UZ';
  static String get holySee => 'VA';
  static String get saintVincentAndTheGrenadines => 'VC';
  static String get venezuela => 'VE';
  static String get britishVirginIslands => 'VG';
  static String get usVirginIslands => 'VI';
  static String get vietnam => 'VN';
  static String get vanuatu => 'VU';
  static String get wallisAndFutunaIslands => 'WF';
  static String get samoa => 'WS';
  static String get yemen => 'YE';
  static String get mayotte => 'YT';
  static String get southAfrica => 'ZA';
  static String get zambia => 'ZM';
  static String get zimbabwe => 'ZW';
}

class Language {
  static String get englishUS => 'en_us';
  static String get englishUK => 'en_uk';
  static String get german => 'de_de';
  static String get french => 'fr_fr';
  static String get italian => 'it_it';
  static String get spanish => 'es_es';
  static String get portuguese => 'pt_pt';
  static String get dutch => 'nl_nl';
  static String get russian => 'ru_ru';
  static String get chinese => 'zh_cn';
  static String get japanese => 'ja_jp';
  static String get korean => 'ko_kr';
  static String get arabic => 'ar_sa';
  static String get turkish => 'tr_tr';
  static String get thai => 'th_th';
  static String get vietnamese => 'vi_vn';
  static String get indonesian => 'id_id';
  static String get malay => 'ms_my';
  static String get filipino => 'fil_ph';
  static String get hindi => 'hi_in';
  static String get bengali => 'bn_in';
  static String get telugu => 'te_in';
  static String get tamil => 'ta_in';
  static String get marathi => 'mr_in';
  static String get gujarati => 'gu_in';
  static String get kannada => 'kn_in';
  static String get punjabi => 'pa_in';
  static String get urdu => 'ur_pk';
  static String get nepali => 'ne_np';
  static String get sinhala => 'si_lk';
  static String get burmese => 'my_mm';
  static String get khmer => 'km_kh';
  static String get lao => 'lo_la';
  static String get tibetan => 'bo_cn';
  static String get mongolian => 'mn_mn';
  static String get uzbek => 'uz_uz';
  static String get kazakh => 'kk_kz';
  static String get turkmen => 'tk_tm';
  static String get kyrgyz => 'ky_kg';
  static String get tajik => 'tg_tj';
  static String get pashto => 'ps_af';
  static String get dari => 'fa_af';
  static String get farsi => 'fa_ir';
  static String get armenian => 'hy_am';
  static String get azerbaijani => 'az_az';
  static String get georgian => 'ka_ge';
  static String get maltese => 'mt_mt';
  static String get icelandic => 'is_is';
  static String get swedish => 'sv_se';
  static String get danish => 'da_dk';
  static String get norwegian => 'nb_no';
  static String get finnish => 'fi_fi';
  static String get czech => 'cs_cz';
  static String get slovak => 'sk_sk';
  static String get hungarian => 'hu_hu';
  static String get polish => 'pl_pl';
  static String get romanian => 'ro_ro';
  static String get bulgarian => 'bg_bg';
  static String get greek => 'el_gr';
  static String get turkishTR => 'tr_tr';
  static String get ukrainian => 'uk_ua';
  static String get croatian => 'hr_hr';
  static String get serbian => 'sr_rs';
  static String get slovenian => 'sl_si';
  static String get estonian => 'et_ee';
  static String get latvian => 'lv_lv';
  static String get lithuanian => 'lt_lt';
  static String get malayalam => 'ml_in';
  static String get kannadaIN => 'kn_in';
  static String get teluguIN => 'te_in';
}

extension MediaExtension on Media {
  String get author => switch (this) {
        Media.movie => 'directorTerm',
        Media.podcast => 'artistTerm',
        Media.music => 'artistTerm',
        Media.musicVideo => 'artistTerm',
        Media.audiobook => 'authorTerm',
        Media.shortFilm => 'artistTerm',
        Media.software => 'softwareDeveloper',
        Media.tvShow => 'actorTerm',
        Media.ebook => 'authorTerm',
        Media.all => 'allArtistTerm',
      };

  String get title => switch (this) {
        Media.movie => 'movieTerm',
        Media.podcast => 'titleTerm',
        Media.music => 'songTerm',
        Media.musicVideo => 'songTerm',
        Media.audiobook => 'titleTerm',
        Media.shortFilm => 'shortFilmTerm',
        Media.software => 'softwareTerm',
        Media.tvShow => 'showTerm',
        Media.ebook => 'titleTerm',
        Media.all => 'titleTerm',
      };
}

class AudiobookTunes {
  const AudiobookTunes({
    required this.artist,
    required this.title,
    this.coverUrl,
    this.price,
    this.genre,
    this.description,
  });

  static AudiobookTunes fromJson(Map<String, dynamic> json) {
    return AudiobookTunes(
      artist: json['artistName'] ?? 'Unknown',
      title: json['collectionName'] ?? 'Unknown',
      coverUrl: json['artworkUrl100'],
      price: (value: json['collectionPrice'], currency: json['currency']),
      genre: json['primaryGenreName'],
      description: json['description'],
    );
  }

  final String artist;
  final String title;
  final String? coverUrl;
  final ({double value, String currency})? price;
  final String? genre;
  final String? description;
}

Future<List<AudiobookTunes>?> queryiTunes({
  String? title,
  String? author,
  Media media = Media.all,
  String? store,
  String? lang,
  int limit = 10,
}) async {
  if (title == null && author == null) return null;
  List<dynamic>? byTitle = null;
  if (title != null)
    byTitle = await _queryiTunes(
      term: title,
      media: media.name,
      attribute: media.title,
      store: store,
      lang: lang,
      limit: limit,
    );
  List<dynamic>? byAuthor = null;
  if (author != null)
    byAuthor = await _queryiTunes(
      term: author,
      media: media.name,
      attribute: media.author,
      store: store,
      lang: lang,
      limit: limit,
    );
  List<dynamic> result = <dynamic>[];
  if (byTitle == null && byAuthor == null) return null;
  if (byTitle == null) result = byAuthor!;
  if (byAuthor == null) result = byTitle!;
  if (byTitle != null && byAuthor != null) {
    result = <dynamic>[];
    final List<dynamic> titleExcAuthor = <dynamic>[];
    for (final dynamic e in byTitle) {
      if (byAuthor.contains(e))
        result.add(e);
      else
        titleExcAuthor.add(e);
    }
    result.addAll(titleExcAuthor);

    for (final dynamic e in byAuthor) {
      if (!byTitle.contains(e)) result.add(e);
    }
  }

  final List<AudiobookTunes> songs = <AudiobookTunes>[];
  for (final Map<String, dynamic> e in result) {
    songs.add(AudiobookTunes.fromJson(e));
  }
  return songs.sublist(0, limit);
}

/// Returns either null, or a non-empty list of results.
Future<List<dynamic>?> _queryiTunes({
  required String term,
  String? media,
  String? attribute,
  String? store,
  String? lang,
  int limit = 10,
}) async {
  const String baseUrl = 'itunes.apple.com';

  final Map<String, String> queryParameters = <String, String>{
    'term': term,
  };
  if (media != null) queryParameters.addAll(<String, String>{'media': media});
  if (attribute != null) queryParameters.addAll(<String, String>{'attribute': attribute});
  queryParameters.addAll(<String, String>{'limit': '$limit'});
  if (store != null) queryParameters.addAll(<String, String>{'country': store});
  if (lang != null) queryParameters.addAll(<String, String>{'lang': lang});

  try {
    final Uri request = Uri.https(
      baseUrl,
      'search',
      queryParameters,
    );
    final http.Response response = await http.get(request);
    if (response.statusCode != 200) {
      print('iTunes did not respond with status code 200. (URL: $request) Response body was: ${response.body}');
      return null;
    }
    final List<dynamic>? list = json.decode(response.body)['results'] as List<dynamic>?;
    if (list == null || list.isEmpty) return null;
    return list;
  } catch (e) {
    rethrow;
  }
}
