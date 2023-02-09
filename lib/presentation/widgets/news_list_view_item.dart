import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/models/news.dart';

class NewsItem extends StatelessWidget {
  final News news;
  const NewsItem(this.news);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 180,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      news.image.toString(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 15,
                bottom: 5,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {},
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        'assets/images/save.png',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  news.title.toString(),
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      color: Color(0xff1D1A61),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  maxLines: 3,
                ),
                Text(
                  news.summary.toString(),
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: const Color(0xff1D1A61),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(news.modifiedAt!),
                    style: GoogleFonts.openSans(
                      fontStyle: FontStyle.italic,
                      color: const Color(0xff1D1A61),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
