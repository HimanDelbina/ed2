import 'dart:convert';

List<SalaryModel> salaryModelFromJson(String str) => List<SalaryModel>.from(
    json.decode(str).map((x) => SalaryModel.fromJson(x)));

String salaryModelToJson(List<SalaryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalaryModel {
  int? id;
  DateTime? createAt;
  String? melliCode;
  String? hoghoghPaie;
  String? nerkhHoghoghRozane;
  String? haghOlad;
  String? haghKharbar;
  String? haghGhaza;
  String? padashHaghJazb;
  String? haghTahaol;
  String? bimeOmr;
  String? haghMaskan;
  String? kharidForoshgah;
  String? ghestVam;
  String? mandeVamSandogh;
  String? ghestVamZarori;
  String? mandeVamZarori;
  String? zakhireSandogh;
  String? haghOzviatSandogh;
  String? mosaede;
  String? mandeMosaede;
  String? haghSanavat;
  String? haghBon;
  String? nobatkari15;
  String? nobatkari10;
  String? nobatkari35;
  String? nobatkari22;
  String? nobatkari16;
  String? bimeSahmKarmand;
  String? maliat;
  String? khalesPardakhti;
  String? nakhalesPardakhti;
  String? jameKosorat;
  String? morkhasiEstehghaghi;
  String? ezafekariAdi;
  String? ezafekariTatil;
  String? satKarkard;
  String? satShabkari;
  String? satBimari;
  String? mandeMorkhasi;
  String? satJomekari;
  String? jomeKari;
  String? mandeMorkhasiGhabelPardakht;
  String? bimeTakmiliDarman;
  String? month;
  String? year;

  SalaryModel({
    this.id,
    this.createAt,
    this.melliCode,
    this.hoghoghPaie,
    this.nerkhHoghoghRozane,
    this.haghOlad,
    this.haghKharbar,
    this.haghGhaza,
    this.padashHaghJazb,
    this.haghTahaol,
    this.bimeOmr,
    this.haghMaskan,
    this.kharidForoshgah,
    this.ghestVam,
    this.mandeVamSandogh,
    this.ghestVamZarori,
    this.mandeVamZarori,
    this.zakhireSandogh,
    this.haghOzviatSandogh,
    this.mosaede,
    this.mandeMosaede,
    this.haghSanavat,
    this.haghBon,
    this.nobatkari15,
    this.nobatkari10,
    this.nobatkari35,
    this.nobatkari22,
    this.nobatkari16,
    this.bimeSahmKarmand,
    this.maliat,
    this.khalesPardakhti,
    this.nakhalesPardakhti,
    this.jameKosorat,
    this.morkhasiEstehghaghi,
    this.ezafekariAdi,
    this.ezafekariTatil,
    this.satKarkard,
    this.satShabkari,
    this.satBimari,
    this.mandeMorkhasi,
    this.satJomekari,
    this.jomeKari,
    this.mandeMorkhasiGhabelPardakht,
    this.bimeTakmiliDarman,
    this.month,
    this.year,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) => SalaryModel(
        id: json["id"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        melliCode: json["melli_code"],
        hoghoghPaie: json["hoghogh_paie"],
        nerkhHoghoghRozane: json["nerkh_hoghogh_rozane"],
        haghOlad: json["hagh_olad"],
        haghKharbar: json["hagh_kharbar"],
        haghGhaza: json["hagh_ghaza"],
        padashHaghJazb: json["padash_hagh_jazb"],
        haghTahaol: json["hagh_tahaol"],
        bimeOmr: json["bime_omr"],
        haghMaskan: json["hagh_maskan"],
        kharidForoshgah: json["kharid_foroshgah"],
        ghestVam: json["ghest_vam"],
        mandeVamSandogh: json["mande_vam_sandogh"],
        ghestVamZarori: json["ghest_vam_zarori"],
        mandeVamZarori: json["mande_vam_zarori"],
        zakhireSandogh: json["zakhire_sandogh"],
        haghOzviatSandogh: json["hagh_ozviat_sandogh"],
        mosaede: json["mosaede"],
        mandeMosaede: json["mande_mosaede"],
        haghSanavat: json["hagh_sanavat"],
        haghBon: json["hagh_bon"],
        nobatkari15: json["nobatkari_15"],
        nobatkari10: json["nobatkari_10"],
        nobatkari35: json["nobatkari_35"],
        nobatkari22: json["nobatkari_22"],
        nobatkari16: json["nobatkari_16"],
        bimeSahmKarmand: json["bime_sahm_karmand"],
        maliat: json["maliat"],
        khalesPardakhti: json["khales_pardakhti"],
        nakhalesPardakhti: json["nakhales_pardakhti"],
        jameKosorat: json["jame_kosorat"],
        morkhasiEstehghaghi: json["morkhasi_estehghaghi"],
        ezafekariAdi: json["ezafekari_adi"],
        ezafekariTatil: json["ezafekari_tatil"],
        satKarkard: json["sat_karkard"],
        satShabkari: json["sat_shabkari"],
        satBimari: json["sat_bimari"],
        mandeMorkhasi: json["mande_morkhasi"],
        satJomekari: json["sat_jomekari"],
        jomeKari: json["jome_kari"],
        mandeMorkhasiGhabelPardakht: json["mande_morkhasi_ghabel_pardakht"],
        bimeTakmiliDarman: json["bime_takmili_darman"],
        month: json["month"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "create_at": createAt?.toIso8601String(),
        "melli_code": melliCode,
        "hoghogh_paie": hoghoghPaie,
        "nerkh_hoghogh_rozane": nerkhHoghoghRozane,
        "hagh_olad": haghOlad,
        "hagh_kharbar": haghKharbar,
        "hagh_ghaza": haghGhaza,
        "padash_hagh_jazb": padashHaghJazb,
        "hagh_tahaol": haghTahaol,
        "bime_omr": bimeOmr,
        "hagh_maskan": haghMaskan,
        "kharid_foroshgah": kharidForoshgah,
        "ghest_vam": ghestVam,
        "mande_vam_sandogh": mandeVamSandogh,
        "ghest_vam_zarori": ghestVamZarori,
        "mande_vam_zarori": mandeVamZarori,
        "zakhire_sandogh": zakhireSandogh,
        "hagh_ozviat_sandogh": haghOzviatSandogh,
        "mosaede": mosaede,
        "mande_mosaede": mandeMosaede,
        "hagh_sanavat": haghSanavat,
        "hagh_bon": haghBon,
        "nobatkari_15": nobatkari15,
        "nobatkari_10": nobatkari10,
        "nobatkari_35": nobatkari35,
        "nobatkari_22": nobatkari22,
        "nobatkari_16": nobatkari16,
        "bime_sahm_karmand": bimeSahmKarmand,
        "maliat": maliat,
        "khales_pardakhti": khalesPardakhti,
        "nakhales_pardakhti": nakhalesPardakhti,
        "jame_kosorat": jameKosorat,
        "morkhasi_estehghaghi": morkhasiEstehghaghi,
        "ezafekari_adi": ezafekariAdi,
        "ezafekari_tatil": ezafekariTatil,
        "sat_karkard": satKarkard,
        "sat_shabkari": satShabkari,
        "sat_bimari": satBimari,
        "mande_morkhasi": mandeMorkhasi,
        "sat_jomekari": satJomekari,
        "jome_kari": jomeKari,
        "mande_morkhasi_ghabel_pardakht": mandeMorkhasiGhabelPardakht,
        "bime_takmili_darman": bimeTakmiliDarman,
        "month": month,
        "year": year,
      };
}
