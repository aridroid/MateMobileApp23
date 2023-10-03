import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mate_app/Model/job_listing_model.dart';
import 'package:mate_app/Services/job_board_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobBoardController extends GetxController{

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;

  ScrollController _scrollControllerDashBoard = ScrollController();
  ScrollController get scrollControllerDashBoard => _scrollControllerDashBoard;

  ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  List<String> areas = [
    'Global health & development',
    'AI safety & policy',
    'Biosecurity & pandemic prep',
    'Factory farming',
    'Building effective altruism',
    'Climate change',
    'Global priorities research',
    'Nuclear security',
    'Policy & government',
    'Technical'
  ];
  List<String> selectedAreas = [];

  List<String> countryRegion = [
    'USA',
    'Remote, Global'
  ];
  List<String> selectedCountryRegion = [];

  List<String> city = [
    'Washington, DC metro area',
    'San Francisco Bay Area',
    'Boston metro area',
    'Seattle metro area',
    'New York, NY',
    'Chicago, IL',
    'Los Angeles, CA',
    'Various, USA',
    'Baltimore metro area',
    'Denver metro area',
    'Miami metro area',
    ''
  ];
  List<String> selectedCity = [];

  List<String> organisation = [
    'US Government',
    'OpenAI',
    'GiveDirectly',
    'Anthropic',
    'Evidence Action',
    'carnegie Mellon University',
    'RAND Corporation',
    'Anser(US government role',
    'Microsoft',
    'University of Chicago',
    'Bill and Melinda Gates Foundation',
    'Founder Pledge',
    'Center for Strategic and International Studies',
    'ProVeg International',
    'Animal Equality',
    'Lawrence Livemore National Laboratory',
    'Massachusetts Institute of Technology',
    'Biobot Analytics',
    'Ginkgo Bioworks',
    'IDinsight',
    'Open Philanthropy',
    'Living Goods',
    'New Incentive',
    'Partnership for Public Service',
    '1Day Sooner',
    'Alan Turing Institute',
    'Clean Air Task Force',
    'Helen Keller International',
    'Innovations for Poverty Action',
    'Organisation for Economic Co-operation and Development',
    'Ought',
    'Trail of Bits',
    'Advanced Research and Invention Agency',
    'American Enterprise Institute',
    'Cambridge University',
    'Center for Global Development',
    'Center for a New American Security',
    'Eleanor Crook Foundation',
    'FAR AI',
    'Fish Welfare Initiative',
    'German Marshall Fund',
    'Hudson Institute',
    'The Good Food Institute',
    '80,000 Hours',
    'Atlantic Council',
    'Clinton Health Access Initiative',
    'Committee for a Responsible Federal Budget',
    'Council on Foreign Relations',
    'Council on Strategic Risks',
    'EA Funds',
    'Effective Ventures Operations',
    'Giving What We Can',
    'Global Health Investment Corporation',
    'Google',
    'In-Q-tel',
    'Institute of Electrical and Electronics Engineers',
    'Intel',
    'Johns Hopkins University',
    'Legal Impact for Chickens',
    'Lightcone Infrastructure',
    'PopVax',
    'Protect AI',
    'The Breakthrough Institute',
    'The Future Society',
    'The Humane League',
    'The Stimson Center',
    'University of California',
    'University of Washington',
    'Village Enterprise',
    'We Animals Media',
    'AIGS Canada',
    'ARPA-H',
    'ASML',
    'Against Malaria Foundation',
    'Alliance to Feed the Earth in Disaster',
    'Animal Outlook',
    'Apollo Research',
    'Apple',
    'Apriori',
    'Brookings Institute',
    'Brown Institute',
    'Cambridge Boston Alignment Initiative',
    'Center for AI Policy',
    'Center on Long-Term Risk',
    'Centivax',
    'Center for International Governance Innovation',
    'Cloudflare',
    'Commonwealth Scientific and Industrial Research Organisation',
    'Compassion in World Farming',
    'Credo AI',
    'Essential',
    'Federation of American Scientists',
    'Fred Hutchinson Cencer Research Center, Bedford Lab',
    'Future of Life Institute',
    'Gavi',
    'Geneava Center for Security Policy',
    'George Mason University',
    'GiveWell',
    'Gryphon Scientific',
    'Harvard University',
    'Hoxton Farms',
    'Imapact Academy',
    'Legal Priorities Project',
    'Malaria Consortium',
    'Mercy of Animals',
    'NS Nanotech',
    'Palisade Research',
    'Partnership of AI',
    'Precision Development',
    'Qwiet AI',
    'R Street Institute',
    'Redwood Research',
    'Rethink Priorities',
    'Sherlock Biosciences',
    'SpectorOps',
    'Stockholm International Peace Research Institute',
    'Suvita',
    'The Royal Society',
    'Third way',
    'Two Siz Technologies',
    'Visa',
    'Watershed',
    'AI Safety Hub',
    'AMD',
    'ARPA-E',
    'Alignment Research Center',
    'Alignment Research Center, Evaluation Project',
    'Amazon',
    'American Association for the Advancement of Science',
    'Animal Law Foundation',
    'Arc Institute',
    'Ark Biotech',
    'Aspen Institute',
    'Astera',
    'Berkley AI Safety Initiative for Students',
    'Bipartisan Policy Center',
    'Bosch Center for Artificial Intelligence',
    'Canva',
    'Carbon180',
    'Carnegie Endowment for International Peace',
    'Center for Democracy and Technology',
    'Center for Election Science',
    'Center for Enabling EA Learning and Research',
    'Center for Long-term Resilience',
    'Center for the Governance of AI',
    'Charity Entrepreneurship',
    'Chatham House',
    'Chicago Council on Global Affairs',
    'Climate Advisers',
    'Conjecture',
    'Convergence Analysis',
    'Convergent Research',
    'Digital Harbor Foundation',
    'Effective Institute Project',
    'Epoch',
    'Equalia',
    'Eurogroup for Animals',
    'Foreign Policy Group',
    'Fortify Health',
    'Future Cleantech Architects',
    'Gates Ventures',
    'Georgetown University',
    'Global Index on Responsible AI',
    'Henry Luce Foundation',
    'Humane',
    'ICF',
    'Inflection AI',
    'Information Technology and Innovation Foundation',
    'Institute of Defense Analyses',
    'Institute of Government',
    'International Rescue Committee',
    'Lead Exposure Elimination Project',
    'Leap Labs',
    'Lever Foundation',
    'MIT Technology Review',
    'McCain Institute',
    'Meta',
    'Mindgard',
    'National Bureau of Economic Research',
    'National Defence Industrial Association, Emerging Technology Institute',
    'New American Foundation',
    'Non-trivial',
    'Nucleate',
    'Our World In Data',
    'Palo Alto Networks',
    'Pardee RAND Graduate School',
    'Peraton (US Government role)',
    'Ploughsshres Fund',
    'Pure Earth',
    'Robert Wood Johnson Foundation',
    'Sante Fe Institute',
    'Scoville Peace Fellowship',
    'Secure World Foundation',
    'SecureBio',
    'Shrimp Welfare Project',
    'Sophos',
    'Stanford University',
    'Stiftung Neue Verantwortung',
    'TechNet',
    'Tesla',
    'The Board Institute',
    'The Global Fund',
    'The Hertz Foundation',
    'The Life You Can Save',
    'The Long Now',
    'Training for Good',
    'Transformative Futures Institute',
    'United Nations, UN University',
    'United States Federal Reserve',
    'University of Canterbury',
    'University of Hamburg, Institute for Peace Research and Security Policy',
    'Various',
    'Various Biotech Companies / Research Institutes',
    'Various Course Providers',
    'Various US Universities',
    'Various Venture-backend Startups',
    'Vectra AI',
    'Wellcome Trust',
    'World Economic Forum',
    'cFactual',
    'fp21'
  ];
  List<String> selectedOrganisation = [];

  List<String> experience = [
    'Entry-level',
    'Junior (1-4 years experience)'
  ];
  List<String> selectedExperience = [];

  List<String> education = ['Undergraduate degree or less'];
  List<String> selectedEducation = [];

  List<String> skillSet = [
    'Research',
    'Operations',
    'Policy',
    'Management',
    'Software engineering',
    'Information security',
    'Outreach',
    'Other',
    'Data',
    'Engineering',
    'Legal'
  ];
  List<String> selectedSkillSet = [];

  List<String> roleType = [
    'Full-time',
    'Internship',
    'Fellowship',
    'Funding',
    'Part-time',
  ];
  List<String> selectedRoleType = [];

  bool get showClearButton =>
      selectedAreas.isNotEmpty ||
          selectedCountryRegion.isNotEmpty ||
          selectedCity.isNotEmpty ||
          selectedOrganisation.isNotEmpty ||
          selectedExperience.isNotEmpty ||
          selectedEducation.isNotEmpty ||
          selectedSkillSet.isNotEmpty ||
          selectedRoleType.isNotEmpty;

  int selectedAreasPreviousLength = 0;
  int selectedCountryRegionPreviousLength = 0;
  int selectedCityPreviousLength = 0;
  int selectedOrganisationPreviousLength = 0;
  int selectedExperiencePreviousLength = 0;
  int selectedEducationPreviousLength = 0;
  int selectedSkillSetPreviousLength = 0;
  int selectedRoleTypePreviousLength = 0;

  List<String> selectedAreasPreviousValue = [];
  List<String> selectedCountryRegionPreviousValue = [];
  List<String> selectedCityPreviousValue = [];
  List<String> selectedOrganisationPreviousValue = [];
  List<String> selectedExperiencePreviousValue = [];
  List<String> selectedEducationPreviousValue = [];
  List<String> selectedSkillSetPreviousValue = [];
  List<String> selectedRoleTypePreviousValue = [];

  void setPreviousCountAndValue(){
    selectedAreasPreviousLength = selectedAreas.length;
    selectedCountryRegionPreviousLength = selectedCountryRegion.length;
    selectedCityPreviousLength = selectedCity.length;
    selectedOrganisationPreviousLength = selectedOrganisation.length;
    selectedExperiencePreviousLength = selectedExperience.length;
    selectedEducationPreviousLength = selectedEducation.length;
    selectedSkillSetPreviousLength = selectedSkillSet.length;
    selectedRoleTypePreviousLength = selectedRoleType.length;

    selectedAreasPreviousValue = selectedAreas;
    selectedCountryRegionPreviousValue = selectedCountryRegion;
    selectedCityPreviousValue = selectedCity;
    selectedOrganisationPreviousValue = selectedOrganisation;
    selectedExperiencePreviousValue = selectedExperience;
    selectedEducationPreviousValue = selectedEducationPreviousValue;
    selectedSkillSetPreviousValue = selectedSkillSetPreviousValue;
    selectedRoleTypePreviousValue = selectedRoleType;
  }

  Function eq = const ListEquality().equals;

  bool get applyFilter =>
      selectedAreas.length != selectedAreasPreviousLength ||
          selectedCountryRegion.length != selectedCountryRegionPreviousLength ||
          selectedCity.length != selectedCityPreviousLength ||
          selectedOrganisation.length != selectedOrganisationPreviousLength ||
          selectedExperience.length != selectedExperiencePreviousLength ||
          selectedEducation.length != selectedEducationPreviousLength ||
          selectedSkillSet.length != selectedSkillSetPreviousLength ||
          selectedRoleType.length != selectedRoleTypePreviousLength ||

          !eq(selectedAreasPreviousValue, selectedAreas) ||
          !eq(selectedCountryRegionPreviousValue, selectedCountryRegion) ||
          !eq(selectedCityPreviousValue, selectedCity) ||
          !eq(selectedOrganisationPreviousValue, selectedOrganisation) ||
          !eq(selectedExperiencePreviousValue, selectedExperience) ||
          !eq(selectedEducationPreviousValue, selectedEducation) ||
          !eq(selectedSkillSetPreviousValue, selectedSkillSet) ||
          !eq(selectedRoleTypePreviousValue, selectedRoleType) ;


  void clearAllFilter(){
    selectedAreas.clear();
    selectedCountryRegion.clear();
    selectedCity.clear();
    selectedOrganisation.clear();
    selectedExperience.clear();
    selectedEducation.clear();
    selectedSkillSet.clear();
    selectedRoleType.clear();
    update();
  }

  Timer? _throttle;
  onSearchChanged() {
    if (_throttle?.isActive??false) _throttle?.cancel();
    _throttle = Timer(const Duration(milliseconds: 500), () {
      if(_textEditingController.text.length>2){
        fetchJobListing(true);
      }
    });
  }

  @override
  void onInit() {
    getStoredValue();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    _scrollControllerDashBoard = new ScrollController()..addListener(_scrollListenerDashBorad);
    super.onInit();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _scrollControllerDashBoard.removeListener(_scrollListenerDashBorad);
    _scrollControllerDashBoard.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        fetchJobListing(false);
      }
    }
  }
  void _scrollListenerDashBorad() {
    if (_scrollControllerDashBoard.position.atEdge) {
      if (_scrollControllerDashBoard.position.pixels != 0) {
        fetchJobListing(false);
      }
    }
  }

  bool _isPaginationApplicable = true;
  bool get isPaginationApplicable => _isPaginationApplicable;
  set setIsPaginationApplicable(bool val) => _isPaginationApplicable = val;

  List<Jobs> _jobList = [];
  List<Jobs> get jobList => _jobList;
  set setJobList(List<Jobs> jobs) => _jobList = jobs;

  String token = "";
  int page = 0;
  JobBoardService _jobBoardService = JobBoardService();
  bool isLoading = true;
  bool noDataFound = false;

  getStoredValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
    fetchJobListing(false);
  }

  fetchJobListing(bool resetValue)async{
    resetValue? page = 1: page++;
    noDataFound = false;
    List<Jobs> jobs = await _jobBoardService.getJobListing(
      token: token,
      page: page,
      searchKeyword: _textEditingController.text,
      areas: selectedAreas,
      country: selectedCountryRegion.isNotEmpty?selectedCountryRegion:['USA','Remote, Global'],
      city: selectedCity,
      company: selectedOrganisation,
      experience: selectedExperience.isNotEmpty?selectedExperience:['Entry-level', 'Junior (1-4 years experience)'],
      education: selectedEducation.isNotEmpty?selectedEducation:['Undergraduate degree or less'],
      skills: selectedSkillSet,
      role_types: selectedRoleType,
    );
    if(resetValue){
      _jobList.clear();
    }
    _jobList.addAll(jobs);
    if(isLoading){
      isLoading = false;
    }
    if(_jobList.isEmpty){
      noDataFound = true;
    }
    update();
    debugPrint(_jobList.length.toString());
  }

}