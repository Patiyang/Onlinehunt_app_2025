import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/periodicals_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/pdf_epaper.dart';
import 'package:online_hunt_news/helpers&Widgets/web_epaper.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/provider.dart';

class FortnightlyPeriodicals extends StatefulWidget {
  const FortnightlyPeriodicals({super.key});

  @override
  State<FortnightlyPeriodicals> createState() => _FortnightlyPeriodicalsState();
}

class _FortnightlyPeriodicalsState extends State<FortnightlyPeriodicals> {

  @override
  Widget build(BuildContext context) {
    final pb = context.watch<MonthlyPeriodicalBloc>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 23,
                width: 4,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  // pb.getApiData(mounted, context);
                },
                child: Text('fortnightly', style: TextStyle(fontSize: 18, letterSpacing: -0.6, wordSpacing: 1, fontWeight: FontWeight.bold)).tr(),
              ),
              Spacer(),
              // TextButton(
              //   child: Text('view all', style: TextStyle(color: Theme.of(context).primaryColorDark)).tr(),
              //   onPressed: () => nextScreen(context, MoreArticles(title: 'featured news')),
              // ),
            ],
          ),
        ),
        pb.loading == true
            ? Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15), child: LoadingCard(height: 200))
            : Container(
                width: MediaQuery.of(context).size.width,
                // height: 250,
                child: GridView.builder(
                  // padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
                  shrinkWrap: true,
                  // physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.1,),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: pb.data.isEmpty ? 2 : pb.data.length<6?pb.data.length:6,
                  // itemCount: 30,
                  // separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemBuilder: (BuildContext context, int index) {
                    if (pb.data.isEmpty) return LoadingCard(height: 200);
                    EpaperModel paper = pb.data[index];
                    return paper.source_type == 'website' ? URLepaper(epaperModel: paper) : PDFepaper(epaperModel: paper);
                  },
                ),
              ),
      ],
    );
  }  
}