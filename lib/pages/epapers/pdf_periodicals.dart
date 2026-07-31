import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/featured_bloc.dart';
import 'package:online_hunt_news/blocs/pdf_periodicals_bloc.dart';
import 'package:online_hunt_news/blocs/website_periodicals_bloc.dart';
import 'package:online_hunt_news/pages/epapers/pdf_periodical_widgets/daily_epaper.dart';
import 'package:online_hunt_news/pages/epapers/pdf_periodical_widgets/fortnightly_periodicals.dart';
import 'package:online_hunt_news/pages/epapers/pdf_periodical_widgets/monthly_periodicals.dart';
import 'package:online_hunt_news/pages/epapers/pdf_periodical_widgets/weekly_periodicals.dart';
import 'package:online_hunt_news/pages/epapers/website_periodical_widgets/daily_epaper.dart';
import 'package:online_hunt_news/pages/epapers/website_periodical_widgets/fortnightly_periodicals.dart';
import 'package:online_hunt_news/pages/epapers/website_periodical_widgets/monthly_periodicals.dart';
import 'package:online_hunt_news/pages/epapers/website_periodical_widgets/weekly_periodicals.dart';
import 'package:provider/provider.dart';

class PDFPeriodicals extends StatefulWidget {
  const PDFPeriodicals({super.key});

  @override
  State<PDFPeriodicals> createState() => _PDFPeriodicalsState();
}

class _PDFPeriodicalsState extends State<PDFPeriodicals> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    refresh(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        refresh(context);
      },
      child: SingleChildScrollView(
        controller: scrollController,
        key: PageStorageKey('key0'),
        padding: EdgeInsets.symmetric(vertical: 10),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: [DailyPDFEpaper(), WeeklyPDFPeriodical(), FortnightlyPDFPeriodicals(), MonthlyPDFPeriodicals()]),
      ),
    );
  }

  refresh(BuildContext context) {
    context.read<DailyPDFPeriodicalBloc>().onRefresh(mounted);
    context.read<WeeklyPDFPeriodicalBloc>().onRefresh(mounted);
    context.read<FortnightlyPDFPeriodicalBloc>().onRefresh(mounted);
    context.read<MonthlyPDFPeriodicalBloc>().onRefresh(mounted);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
