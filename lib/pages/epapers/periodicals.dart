import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/featured_bloc.dart';
import 'package:online_hunt_news/blocs/periodicals_bloc.dart';
import 'package:online_hunt_news/pages/epapers/periodical_widgets/daily_epaper.dart';
import 'package:online_hunt_news/pages/epapers/periodical_widgets/fortnightly_periodicals.dart';
import 'package:online_hunt_news/pages/epapers/periodical_widgets/monthly_periodicals.dart';
import 'package:online_hunt_news/pages/epapers/periodical_widgets/weekly_periodicals.dart';
import 'package:provider/provider.dart';

class Periodicals extends StatefulWidget {
  const Periodicals({super.key});

  @override
  State<Periodicals> createState() => _PeriodicalsState();
}

class _PeriodicalsState extends State<Periodicals> with AutomaticKeepAliveClientMixin {
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
        child: Column(children: [DailyEpaper(), WeeklyPeriodical(), FortnightlyPeriodicals(), MonthlyPeriodicals()]),
      ),
    );
  }

  refresh(BuildContext context) {
    context.read<DailyPeriodicalBloc>().onRefresh(mounted);

    context.read<WeeklyPeriodicalBloc>().onRefresh(mounted);
    context.read<FortnightlyPeriodicalBloc>().onRefresh(mounted);
    context.read<MonthlyPeriodicalBloc>().onRefresh(mounted);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
