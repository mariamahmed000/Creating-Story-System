class emotion {
  dynamic Aggression;

  dynamic Anxiety;

  dynamic anger;

  dynamic fear;

  dynamic happy;

  dynamic sad;

  dynamic satisfied;

  dynamic surprised;

  emotion({
    required this.Aggression,
    required this.anger,
    required this.Anxiety,
    required this.fear,
    required this.happy,
    required this.sad,
    required this.satisfied,
    required this.surprised
  });

  factory emotion.fromJson (Map<String, dynamic> json){
    return emotion(Aggression: json['Aggression'],
        anger: json['anger'],
        Anxiety: json['Anxiety'],
        fear: json['fear'],
        happy: json['happy'],
        sad: json['sad'],
        satisfied: json['satisfied'],
        surprised: json['surprised']);
  }
}