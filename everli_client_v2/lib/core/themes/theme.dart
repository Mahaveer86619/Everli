import 'package:everli_client_v2/core/themes/pallet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    //* BACKGROUND and SURFACE
    surface: Pallete.everliBackground,
    onSurface: Pallete.everliText,
    background: Colors.white,
    onBackground: Pallete.everliText,

    //* PRIMARY
    primary: Pallete.everliPrimary,
    onPrimary: Colors.white,
    primaryContainer: Pallete.everliPrimaryLight,
    onPrimaryContainer: Pallete.everliPrimaryDark,

    //* SECONDARY
    secondary: Pallete.everliSecondary,
    onSecondary: Colors.white,
    secondaryContainer: Pallete.everliSecondary.withAlpha(70), // 30% opacity
    onSecondaryContainer: Colors.black,

    //* TERTIARY
    tertiary: Pallete.greenColor,
    onTertiary: Colors.white,

    //* ERROR
    error: Pallete.errorColor,
    onError: Colors.white,
    errorContainer: Pallete.errorColor.withAlpha(70), // 30% opacity
    onErrorContainer: Colors.black,
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.nunitoSansTextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    enableFeedback: false,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedItemColor: Pallete.everliPrimary,
    unselectedItemColor: Pallete.everliSecondary,
    selectedIconTheme: IconThemeData(color: Pallete.everliPrimary),
    unselectedIconTheme: IconThemeData(color: Pallete.everliSecondary),
    selectedLabelStyle: TextStyle(color: Pallete.everliPrimary),
    unselectedLabelStyle: TextStyle(color: Pallete.everliSecondary),
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    //* BACKGROUND and SURFACE
    surface: Color(0xFF32353A),
    onSurface: Color(0xFFE1E2E8),
    background: Color(0xFF111418),
    onBackground: Color(0xFFE1E2E8),

    //* PRIMARY
    primary: Color(0xFFA0CAFD),
    onPrimary: Color(0xFF003258),
    primaryContainer: Color(0xFF194975),
    onPrimaryContainer: Color(0XFFD1E4FF),

    //* SECONDARY
    secondary: Color(0xFFBBC7DB),
    onSecondary: Color(0xFF253140),
    secondaryContainer: Color(0xFF3B4858),
    onSecondaryContainer: Color(0xFFD7E3F7),

    //* TERTIARY
    tertiary: Color(0xFFD6BEE4),
    onTertiary: Color(0xFF3B2948),
    tertiaryContainer: Color(0xFF523F5F),
    onTertiaryContainer: Color(0xFFF2DAFF),

    //* ERROR
    error: Color(0XFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0XFFFFDAD6),
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.nunitoSansTextTheme(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.shifting,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedItemColor: Color(0xFF116682),
    unselectedItemColor: Color(0xFF253140),
    selectedIconTheme: IconThemeData(
      color: Color(0xFF116682),
    ),
    unselectedIconTheme: IconThemeData(
      color: Color(0xFF253140),
    ),
    selectedLabelStyle: TextStyle(
      color: Color(0xFF116682),
    ),
    unselectedLabelStyle: TextStyle(
      color: Color(0xFF253140),
    ),
  ),
);
