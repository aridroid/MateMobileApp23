class JobListingModel {
  JobListingModel({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final Data data;

  JobListingModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.jobs,
    // required this.links,
    // required this.meta,
  });
  late final List<Jobs> jobs;
  // late final Links links;
  // late final Meta meta;

  Data.fromJson(Map<String, dynamic> json){
    jobs = List.from(json['jobs']).map((e)=>Jobs.fromJson(e)).toList();
    // links = Links.fromJson(json['links']);
    // meta = Meta.fromJson(json['meta']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['jobs'] = jobs.map((e)=>e.toJson()).toList();
    // _data['links'] = links.toJson();
    // _data['meta'] = meta.toJson();
    return _data;
  }
}

class Jobs {
  Jobs({
    required this.id,
    required this.postPk,
    required this.title,
    required this.description,
    required this.idExternal_80_000Hours,
    this.closesAt,
    required this.postedAt,
    required this.urlExternal,
    required this.experienceMin,
    required this.experienceAvg,
    required this.salaryMin,
    required this.salaryMax,
    required this.salary,
    required this.visaSponsorship,
    required this.evergreen,
    required this.careerDevelopmentRole,
    required this.textHover,
    required this.companyDetails,
    required this.countries,
    required this.cities,
    required this.areas,
    required this.skills,
    required this.experience,
    required this.composite,
    required this.compositeName,
    this.moreDetails,
  });
  late final int id;
  late final int postPk;
  late final String title;
  late final String description;
  late final String idExternal_80_000Hours;
  late final String? closesAt;
  late final String postedAt;
  late final String urlExternal;
  late final int experienceMin;
  late final int experienceAvg;
  late final String salaryMin;
  late final String salaryMax;
  late final String salary;
  late final int visaSponsorship;
  late final int evergreen;
  late final int careerDevelopmentRole;
  late final String textHover;
  late final CompanyDetails companyDetails;
  late final List<String> countries;
  late final List<String> cities;
  late final List<String> areas;
  late final List<String> skills;
  late final List<String> experience;
  late final String composite;
  late final String compositeName;
  late final MoreDetails? moreDetails;

  Jobs.fromJson(Map<String, dynamic> json){
    id = json['id'];
    postPk = json['post_pk'];
    title = json['title'];
    description = json['description'];
    idExternal_80_000Hours = json['id_external_80_000_hours'];
    closesAt = json['closes_at']??"";
    postedAt = json['posted_at'];
    urlExternal = json['url_external'];
    experienceMin = json['experience_min'];
    experienceAvg = json['experience_avg'];
    salaryMin = json['salary_min'];
    salaryMax = json['salary_max'];
    salary = json['salary'];
    visaSponsorship = json['visa_sponsorship'];
    evergreen = json['evergreen'];
    careerDevelopmentRole = json['career_development_role'];
    textHover = json['text_hover'];
    companyDetails = CompanyDetails.fromJson(json['company_details']);
    countries = List.castFrom<dynamic, String>(json['countries']);
    cities = List.castFrom<dynamic, String>(json['cities']);
    areas = List.castFrom<dynamic, String>(json['areas']);
    skills = List.castFrom<dynamic, String>(json['skills']);
    experience = List.castFrom<dynamic, String>(json['experience']);
    composite = json['composite'];
    compositeName = json['composite_name'];
    moreDetails = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['post_pk'] = postPk;
    _data['title'] = title;
    _data['description'] = description;
    _data['id_external_80_000_hours'] = idExternal_80_000Hours;
    _data['closes_at'] = closesAt;
    _data['posted_at'] = postedAt;
    _data['url_external'] = urlExternal;
    _data['experience_min'] = experienceMin;
    _data['experience_avg'] = experienceAvg;
    _data['salary_min'] = salaryMin;
    _data['salary_max'] = salaryMax;
    _data['salary'] = salary;
    _data['visa_sponsorship'] = visaSponsorship;
    _data['evergreen'] = evergreen;
    _data['career_development_role'] = careerDevelopmentRole;
    _data['text_hover'] = textHover;
    _data['company_details'] = companyDetails.toJson();
    _data['countries'] = countries;
    _data['cities'] = cities;
    _data['areas'] = areas;
    _data['skills'] = skills;
    _data['experience'] = experience;
    _data['composite'] = composite;
    _data['composite_name'] = compositeName;
    _data['more_details'] = moreDetails;
    return _data;
  }
}

class CompanyDetails {
  CompanyDetails({
    required this.id,
    required this.refPk,
    required this.name,
    required this.url,
    required this.logoUrl,
    required this.careerPageUrl,
    required this.forumUrl,
    required this.isTopRecommendedOrg,
    required this.description,
  });
  late final int id;
  late final String refPk;
  late final String name;
  late final String url;
  late final String logoUrl;
  late final String careerPageUrl;
  late final String forumUrl;
  late final int isTopRecommendedOrg;
  late final String description;

  CompanyDetails.fromJson(Map<String, dynamic> json){
    id = json['id'];
    refPk = json['ref_pk'];
    name = json['name'];
    url = json['url'];
    logoUrl = json['logo_url'];
    careerPageUrl = json['career_page_url'];
    forumUrl = json['forum_url'];
    isTopRecommendedOrg = json['is_top_recommended_org'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ref_pk'] = refPk;
    _data['name'] = name;
    _data['url'] = url;
    _data['logo_url'] = logoUrl;
    _data['career_page_url'] = careerPageUrl;
    _data['forum_url'] = forumUrl;
    _data['is_top_recommended_org'] = isTopRecommendedOrg;
    _data['description'] = description;
    return _data;
  }
}

class MoreDetails {
  MoreDetails({
    required this.id,
    required this.pk,
    required this.name,
    required this.url,
    required this.logoUrl,
    required this.careerPageUrl,
    required this.forumUrl,
    required this.isHighlighted,
    required this.description,
    required this.jobId,
  });
  late final int id;
  late final String pk;
  late final String name;
  late final String url;
  late final String logoUrl;
  late final String careerPageUrl;
  late final String forumUrl;
  late final int isHighlighted;
  late final String description;
  late final int jobId;

  MoreDetails.fromJson(Map<String, dynamic> json){
    id = json['id'];
    pk = json['pk'];
    name = json['name'];
    url = json['url'];
    logoUrl = json['logo_url'];
    careerPageUrl = json['career_page_url'];
    forumUrl = json['forum_url'];
    isHighlighted = json['is_highlighted'];
    description = json['description'];
    jobId = json['job_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['pk'] = pk;
    _data['name'] = name;
    _data['url'] = url;
    _data['logo_url'] = logoUrl;
    _data['career_page_url'] = careerPageUrl;
    _data['forum_url'] = forumUrl;
    _data['is_highlighted'] = isHighlighted;
    _data['description'] = description;
    _data['job_id'] = jobId;
    return _data;
  }
}

class Links {
  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });
  late final String first;
  late final String last;
  late final String prev;
  late final String next;

  Links.fromJson(Map<String, dynamic> json){
    first = json['first'];
    last = json['last'];
    prev = json['prev']??"";
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['first'] = first;
    _data['last'] = last;
    _data['prev'] = prev;
    _data['next'] = next;
    return _data;
  }
}

class Meta {
  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    //required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });
  late final int currentPage;
  late final int from;
  late final int lastPage;
  //late final List<Links> links;
  late final String path;
  late final int perPage;
  late final int to;
  late final int total;

  Meta.fromJson(Map<String, dynamic> json){
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    //links = List.from(json['links']).map((e)=>Links.fromJson(e)).toList();
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['current_page'] = currentPage;
    _data['from'] = from;
    _data['last_page'] = lastPage;
    //_data['links'] = links.map((e)=>e.toJson()).toList();
    _data['path'] = path;
    _data['per_page'] = perPage;
    _data['to'] = to;
    _data['total'] = total;
    return _data;
  }
}