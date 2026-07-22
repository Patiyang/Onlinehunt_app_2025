import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:online_hunt_news/blocs/periodicals_bloc.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/pdf_epaper.dart';
import 'package:online_hunt_news/helpers&Widgets/widgets/web_epaper.dart';
import 'package:online_hunt_news/models/epaper_model.dart';
import 'package:online_hunt_news/utils/loading_cards.dart';
import 'package:provider/provider.dart';

class MonthlyPeriodicals extends StatefulWidget {
  const MonthlyPeriodicals({super.key});

  @override
  State<MonthlyPeriodicals> createState() => _MonthlyPeriodicalsState();
}

class _MonthlyPeriodicalsState extends State<MonthlyPeriodicals> {

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MonthlyPeriodicalBloc>();
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
                child: Text('monthly', style: TextStyle(fontSize: 18, letterSpacing: -0.6, wordSpacing: 1, fontWeight: FontWeight.bold)).tr(),
              ),
              Spacer(),
              // TextButton(
              //   child: Text('view all', style: TextStyle(color: Theme.of(context).primaryColorDark)).tr(),
              //   onPressed: () => nextScreen(context, MoreArticles(title: 'featured news')),
              // ),
            ],
          ),
        ),
        mp.loading == true
            ? Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15), child: LoadingCard(height: 200))
            : Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: ListView.separated(padding: EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: mp.data.isEmpty ? 2 : mp.data.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 10);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    // EpaperModel paper = mp.data[index];

                    return  mp.data.isEmpty
                        ? LoadingCard(height: 300, width: 210):  mp.data[index].source_type == 'website' ? URLepaper(epaperModel: mp.data[index],) : PDFepaper(epaperModel: mp.data[index]);
                  },
                ),
                // child: GridView.builder(
                //   // padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
                //   shrinkWrap: true,
                //   // physics: AlwaysScrollableScrollPhysics(),
                //   padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.1,),
                //   physics: NeverScrollableScrollPhysics(),
                //   scrollDirection: Axis.vertical,
                //   itemCount: mp.data.isEmpty ? 2 : mp.data.length<6?mp.data.length:6,
                //   // itemCount: 30,
                //   // separatorBuilder: (context, index) => SizedBox(height: 15),
                //   itemBuilder: (BuildContext context, int index) {
                //     if (mp.data.isEmpty) return LoadingCard(height: 200);
                //     EpaperModel paper = mp.data[index];
                //     return paper.source_type == 'website' ? URLepaper(epaperModel: paper) : PDFepaper(epaperModel: paper);
                //   },
                // ),
              ),
      ],
    );
  }  
}