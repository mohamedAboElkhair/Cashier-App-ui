import 'package:flutter/material.dart';

/// The Saamsy design-token palette.
///
/// This is the canonical source of truth for colour in the redesigned UI.
/// Access it from a widget via `context.c` (see [SaamsyColorsX] below).
@immutable
class SaamsyColors extends ThemeExtension<SaamsyColors> {
  const SaamsyColors({
    required this.ground,
    required this.surface,
    required this.panel,
    required this.rail,
    required this.railInk,
    required this.railGroup,
    required this.railAccent,
    required this.railLine,
    required this.line,
    required this.lineStrong,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.brand,
    required this.brandDeep,
    required this.brandWash,
    required this.action,
    required this.actionHover,
    required this.onAction,
    required this.ok,
    required this.okWash,
    required this.warn,
    required this.warnWash,
    required this.crit,
    required this.critWash,
    required this.info,
    required this.infoWash,
    required this.idle,
    required this.idleWash,
    required this.onCrit,
  });

  final Color ground;
  final Color surface;
  final Color panel;
  final Color rail;
  final Color railInk;
  final Color railGroup;
  final Color railAccent;
  final Color railLine;
  final Color line;
  final Color lineStrong;
  final Color ink;
  final Color ink2;
  final Color ink3;
  final Color brand;
  final Color brandDeep;
  final Color brandWash;
  final Color action;
  final Color actionHover;
  final Color onAction;
  final Color ok;
  final Color okWash;
  final Color warn;
  final Color warnWash;
  final Color crit;
  final Color critWash;
  final Color info;
  final Color infoWash;
  final Color idle;
  final Color idleWash;
  final Color onCrit;

  static const light = SaamsyColors(
    ground: Color(0xFFF6F6F3),
    surface: Color(0xFFFFFFFF),
    panel: Color(0xFFEDEDE9),
    rail: Color(0xFF1A1B0A),
    railInk: Color(0xFFCBCCBD),
    railGroup: Color(0xFF999A85),
    railAccent: Color(0xFFBDBF48),
    railLine: Color(0xFF343422),
    line: Color(0xFFDDDED8),
    lineStrong: Color(0xFFC3C3BC),
    ink: Color(0xFF1A1A11),
    ink2: Color(0xFF57574F),
    ink3: Color(0xFF66675F),
    brand: Color(0xFF797A1E),
    brandDeep: Color(0xFF535400),
    brandWash: Color(0xFFF1F2DC),
    action: Color(0xFF1A1A11),
    actionHover: Color(0xFF000000),
    onAction: Color(0xFFFFFFFF),
    ok: Color(0xFF00704E),
    okWash: Color(0xFFE1F8EC),
    warn: Color(0xFF884D01),
    warnWash: Color(0xFFFFEDDA),
    crit: Color(0xFFA3212D),
    critWash: Color(0xFFFFE9E7),
    info: Color(0xFF2D6198),
    infoWash: Color(0xFFE4F2FF),
    idle: Color(0xFF696963),
    idleWash: Color(0xFFEDEDE9),
    onCrit: Color(0xFFFFFFFF),
  );

  static const dark = SaamsyColors(
    ground: Color(0xFF15160D),
    surface: Color(0xFF1F2017),
    panel: Color(0xFF2A2B22),
    rail: Color(0xFF0C0C04),
    railInk: Color(0xFFCBCCBD),
    railGroup: Color(0xFF999A85),
    railAccent: Color(0xFFBDBF48),
    railLine: Color(0xFF343422),
    line: Color(0xFF36362D),
    lineStrong: Color(0xFF4D4E43),
    ink: Color(0xFFF3F4EF),
    ink2: Color(0xFFBEBEB6),
    ink3: Color(0xFF9F9F97),
    brand: Color(0xFFBDBF48),
    brandDeep: Color(0xFFBDBF48),
    brandWash: Color(0xFF2F3017),
    action: Color(0xFFBDBF48),
    actionHover: Color(0xFFD2D45F),
    onAction: Color(0xFF15160D),
    ok: Color(0xFF5ED8A9),
    okWash: Color(0xFF143427),
    warn: Color(0xFFF0B758),
    warnWash: Color(0xFF402811),
    crit: Color(0xFFF98281),
    critWash: Color(0xFF472322),
    info: Color(0xFF86BFFF),
    infoWash: Color(0xFF1D2F44),
    idle: Color(0xFFA5A59E),
    idleWash: Color(0xFF2B2C27),
    onCrit: Color(0xFF15160D),
  );

  @override
  SaamsyColors copyWith({
    Color? ground,
    Color? surface,
    Color? panel,
    Color? rail,
    Color? railInk,
    Color? railGroup,
    Color? railAccent,
    Color? railLine,
    Color? line,
    Color? lineStrong,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? brand,
    Color? brandDeep,
    Color? brandWash,
    Color? action,
    Color? actionHover,
    Color? onAction,
    Color? ok,
    Color? okWash,
    Color? warn,
    Color? warnWash,
    Color? crit,
    Color? critWash,
    Color? info,
    Color? infoWash,
    Color? idle,
    Color? idleWash,
    Color? onCrit,
  }) {
    return SaamsyColors(
      ground: ground ?? this.ground,
      surface: surface ?? this.surface,
      panel: panel ?? this.panel,
      rail: rail ?? this.rail,
      railInk: railInk ?? this.railInk,
      railGroup: railGroup ?? this.railGroup,
      railAccent: railAccent ?? this.railAccent,
      railLine: railLine ?? this.railLine,
      line: line ?? this.line,
      lineStrong: lineStrong ?? this.lineStrong,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      brand: brand ?? this.brand,
      brandDeep: brandDeep ?? this.brandDeep,
      brandWash: brandWash ?? this.brandWash,
      action: action ?? this.action,
      actionHover: actionHover ?? this.actionHover,
      onAction: onAction ?? this.onAction,
      ok: ok ?? this.ok,
      okWash: okWash ?? this.okWash,
      warn: warn ?? this.warn,
      warnWash: warnWash ?? this.warnWash,
      crit: crit ?? this.crit,
      critWash: critWash ?? this.critWash,
      info: info ?? this.info,
      infoWash: infoWash ?? this.infoWash,
      idle: idle ?? this.idle,
      idleWash: idleWash ?? this.idleWash,
      onCrit: onCrit ?? this.onCrit,
    );
  }

  @override
  SaamsyColors lerp(ThemeExtension<SaamsyColors>? other, double t) {
    if (other is! SaamsyColors) {
      return this;
    }
    return SaamsyColors(
      ground: Color.lerp(ground, other.ground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      rail: Color.lerp(rail, other.rail, t)!,
      railInk: Color.lerp(railInk, other.railInk, t)!,
      railGroup: Color.lerp(railGroup, other.railGroup, t)!,
      railAccent: Color.lerp(railAccent, other.railAccent, t)!,
      railLine: Color.lerp(railLine, other.railLine, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      ink3: Color.lerp(ink3, other.ink3, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      brandDeep: Color.lerp(brandDeep, other.brandDeep, t)!,
      brandWash: Color.lerp(brandWash, other.brandWash, t)!,
      action: Color.lerp(action, other.action, t)!,
      actionHover: Color.lerp(actionHover, other.actionHover, t)!,
      onAction: Color.lerp(onAction, other.onAction, t)!,
      ok: Color.lerp(ok, other.ok, t)!,
      okWash: Color.lerp(okWash, other.okWash, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      warnWash: Color.lerp(warnWash, other.warnWash, t)!,
      crit: Color.lerp(crit, other.crit, t)!,
      critWash: Color.lerp(critWash, other.critWash, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoWash: Color.lerp(infoWash, other.infoWash, t)!,
      idle: Color.lerp(idle, other.idle, t)!,
      idleWash: Color.lerp(idleWash, other.idleWash, t)!,
      onCrit: Color.lerp(onCrit, other.onCrit, t)!,
    );
  }
}

/// Convenience accessor: `context.c.brand`, `context.c.ink`, etc.
extension SaamsyColorsX on BuildContext {
  SaamsyColors get c =>
      Theme.of(this).extension<SaamsyColors>() ?? SaamsyColors.light;
}
