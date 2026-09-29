import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:templet/core/styling/app_colors.dart';
import 'package:templet/core/styling/app_styles.dart';
import 'package:templet/generated/locale_keys.g.dart';

/// Renders a property Terms & Conditions [sections] list as titled bullet
/// groups in the active app locale (Arabic when `languageCode == 'ar'`, else
/// English), RTL-aware. Each section is a map shaped like
/// `{title_en, title_ar, bullets_en:[...], bullets_ar:[...]}`.
///
/// Shared by the resident signup wizard, the re-agree gate, and the
/// management terms editor preview.
class TermsSectionsView extends StatelessWidget {
  const TermsSectionsView({super.key, required this.sections});

  final List<dynamic> sections;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    if (sections.isEmpty) {
      return Text(
        LocaleKeys.terms_none.tr(),
        style: AppStyles.grey12MediumStyle,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final section in sections)
          if (section is Map) _buildSection(section, isArabic),
      ],
    );
  }

  Widget _buildSection(Map section, bool isArabic) {
    final title =
        (isArabic ? section['title_ar'] : section['title_en'])?.toString() ??
        '';
    final rawBullets = isArabic ? section['bullets_ar'] : section['bullets_en'];
    final bullets = rawBullets is List
        ? rawBullets.map((b) => b?.toString() ?? '').where((b) => b.isNotEmpty)
        : const <String>[];

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) Text(title, style: AppStyles.black15BoldStyle),
          if (title.isNotEmpty) const SizedBox(height: 6),
          for (final bullet in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color: AppColore.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(bullet, style: AppStyles.grey12MediumStyle),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
