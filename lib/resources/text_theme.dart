import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle headline1 = GoogleFonts.notoSerif(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 75,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    letterSpacing: -1.5,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'headline1',
    overflow: TextOverflow.fade,
  ),
);

TextStyle headline2 = GoogleFonts.notoSerif(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 60,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    letterSpacing: -0.5,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'headline2',
    overflow: TextOverflow.fade,
  ),
);

TextStyle headline3 = GoogleFonts.notoSerif(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 48,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'headline3',
    overflow: TextOverflow.fade,
  ),
);

TextStyle headline4 = GoogleFonts.notoSerif(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 34,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.25,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'headline4',
    overflow: TextOverflow.fade,
  ),
);

TextStyle headline5 = GoogleFonts.notoSerif(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.0,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'headline5',
    overflow: TextOverflow.fade,
  ),
);

TextStyle headline6 = GoogleFonts.notoSerif(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.15,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'headline6',
    overflow: TextOverflow.fade,
  ),
);

TextStyle subtitle1 = GoogleFonts.notoSerif(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.15,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'subtitle1',
    overflow: TextOverflow.fade,
  ),
);

TextStyle subtitle2 = GoogleFonts.notoSerif(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.1,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'subtitle2',
    overflow: TextOverflow.fade,
  ),
);
TextStyle bodytext1 = GoogleFonts.notoSans(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.5,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'bodytext1',
    overflow: TextOverflow.fade,
  ),
);

TextStyle bodytext2 = GoogleFonts.notoSans(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.25,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'bodytext2',
    overflow: TextOverflow.fade,
  ),
);

TextStyle caption = GoogleFonts.notoSans(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.4,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'Caption',
    overflow: TextOverflow.fade,
  ),
);

TextStyle button = GoogleFonts.notoSans(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    letterSpacing: 1.25,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'Button',
    overflow: TextOverflow.fade,
  ),
);

TextStyle overline = GoogleFonts.notoSans(
  textStyle: const TextStyle(
    inherit: true,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 1.5,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
    debugLabel: 'Overline',
    overflow: TextOverflow.fade,
  ),
);

TextTheme textTheme = TextTheme(
  headline1: headline1,
  headline2: headline2,
  headline3: headline3,
  headline4: headline4,
  headline5: headline5,
  headline6: headline6,
  subtitle1: subtitle1,
  subtitle2: subtitle2,
  bodyText1: bodytext1,
  bodyText2: bodytext2,
  caption: caption,
  button: button,
  overline: overline,
);
