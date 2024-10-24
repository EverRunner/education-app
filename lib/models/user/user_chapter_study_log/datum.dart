import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
	DateTime? lastVideotime;
	@JsonKey(name: 'keyword_study_chen') 
	DateTime? keywordStudyChen;
	@JsonKey(name: 'keyword_test_chen') 
	DateTime? keywordTestChen;
	@JsonKey(name: 'keyword_test_score_chen') 
	int? keywordTestScoreChen;
	@JsonKey(name: 'keyword_study_en') 
	DateTime? keywordStudyEn;
	@JsonKey(name: 'keyword_test_en') 
	DateTime? keywordTestEn;
	@JsonKey(name: 'keyword_test_score_en') 
	int? keywordTestScoreEn;
	@JsonKey(name: 'uni_test_en') 
	DateTime? uniTestEn;
	@JsonKey(name: 'uni_test_score_en') 
	int? uniTestScoreEn;

	Datum({
		this.lastVideotime, 
		this.keywordStudyChen, 
		this.keywordTestChen, 
		this.keywordTestScoreChen, 
		this.keywordStudyEn, 
		this.keywordTestEn, 
		this.keywordTestScoreEn, 
		this.uniTestEn, 
		this.uniTestScoreEn, 
	});

	factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

	Map<String, dynamic> toJson() => _$DatumToJson(this);
}
