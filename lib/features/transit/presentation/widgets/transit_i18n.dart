import 'package:astrology_app/l10n/app_localizations.dart';

String localizedPlanet(AppLocalizations l10n, String planet) {
  switch (planet.toLowerCase()) {
    case 'sun':
      return l10n.planetSun;
    case 'moon':
      return l10n.planetMoon;
    case 'mercury':
      return l10n.planetMercury;
    case 'venus':
      return l10n.planetVenus;
    case 'mars':
      return l10n.planetMars;
    case 'jupiter':
      return l10n.planetJupiter;
    case 'saturn':
      return l10n.planetSaturn;
    case 'uranus':
      return l10n.planetUranus;
    case 'neptune':
      return l10n.planetNeptune;
    case 'pluto':
      return l10n.planetPluto;
    default:
      return planet;
  }
}

String localizedAspect(AppLocalizations l10n, String aspect) {
  switch (aspect.toLowerCase()) {
    case 'conjunction':
      return l10n.aspectConjunction;
    case 'opposition':
      return l10n.aspectOpposition;
    case 'trine':
      return l10n.aspectTrine;
    case 'square':
      return l10n.aspectSquare;
    case 'sextile':
      return l10n.aspectSextile;
    default:
      return aspect;
  }
}

String localizedSign(AppLocalizations l10n, String sign) {
  switch (sign.toLowerCase()) {
    case 'aries':
      return l10n.signAries;
    case 'taurus':
      return l10n.signTaurus;
    case 'gemini':
      return l10n.signGemini;
    case 'cancer':
      return l10n.signCancer;
    case 'leo':
      return l10n.signLeo;
    case 'virgo':
      return l10n.signVirgo;
    case 'libra':
      return l10n.signLibra;
    case 'scorpio':
      return l10n.signScorpio;
    case 'sagittarius':
      return l10n.signSagittarius;
    case 'capricorn':
      return l10n.signCapricorn;
    case 'aquarius':
      return l10n.signAquarius;
    case 'pisces':
      return l10n.signPisces;
    default:
      return sign;
  }
}
