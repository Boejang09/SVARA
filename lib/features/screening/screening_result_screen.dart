import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/features/dashboard/main_navigation_screen.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class ScreeningResultScreen extends StatelessWidget {
  const ScreeningResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMint,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SvaraWordmark(markSize: 32, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.primaryDarkTeal,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            children: [

              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: CircularProgressIndicator(
                      value: 0.92,
                      strokeWidth: 14,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryTeal,
                      ),
                    ),
                  ),

                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '92',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),

                      Text(
                        'Low Risk',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Screening Complete',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Based on your latest scan, your respiratory and\ncardiac indicators are within healthy ranges.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppTheme.textMuted,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Row(
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color:
                                AppTheme.primaryLightTeal,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),

                          child: const Icon(
                            Icons.settings_suggest_rounded,
                            color: AppTheme.primaryTeal,
                          ),
                        ),

                        const SizedBox(width: 14),

                        const Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              'AI Confidence',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    AppTheme.textMuted,
                              ),
                            ),

                            Text(
                              '98% Accuracy Score',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    AppTheme.primaryDarkTeal,
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: AppTheme.primaryTeal,
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: const Text(
                        'High Reliability',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 12),

              _buildMetricCard(
                icon: Icons.favorite_rounded,
                iconColor: Colors.redAccent,
                title: 'Heart Analysis',
                val: 'Normal',
                subText: '72 BPM Avg',
                progress: 0.75,
              ),

              const SizedBox(height: 12),

              _buildMetricCard(
                icon: Icons.air_rounded,
                iconColor: AppTheme.primaryTeal,
                title: 'Respiratory',
                val: 'Normal',
                subText: '14 BrPM',
                progress: 0.88,
              ),

              const SizedBox(height: 20),
                            // Clinical Recommendations
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Text(
                          'Clinical Recommendations',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                AppTheme.textDark,
                          ),
                        ),

                        Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 18,
                          color:
                              AppTheme.primaryTeal,
                        ),

                      ],
                    ),


                    const SizedBox(height: 14),


                    _buildRecommendationItem(
                      title:
                          'Continue regular monitoring',
                      desc:
                          'Your baseline is stable. Next scan recommended in 7 days.',
                    ),


                    const SizedBox(height: 12),


                    _buildRecommendationItem(
                      title:
                          'Hydration Optimization',
                      desc:
                          'Slight heart rate variability noted; increase water intake before next scan.',
                    ),

                  ],
                ),
              ),


              const SizedBox(height: 24),



              // Save Result Button
              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(

                  onPressed: () {

                    Navigator.of(context)
                        .pushAndRemoveUntil(

                      MaterialPageRoute(
                        builder: (_) =>
                            const MainNavigationScreen(
                              initialIndex: 0,
                            ),
                      ),

                      (route) => false,

                    );

                  },


                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                        AppTheme.primaryDarkTeal,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(27),

                    ),

                  ),


                  child: const Text(
                    'Save Result',

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),

                  ),

                ),

              ),



              const SizedBox(height: 12),



              // Bottom Buttons
              Row(
                children: [


                  Expanded(

                    child: OutlinedButton.icon(

                      onPressed: () {

                        Navigator.of(context)
                            .pushAndRemoveUntil(

                          MaterialPageRoute(
                            builder: (_) =>
                                const MainNavigationScreen(
                                  initialIndex: 0,
                                ),
                          ),

                          (route) => false,

                        );

                      },


                      style:
                          OutlinedButton.styleFrom(

                        backgroundColor:
                            Colors.grey.shade200,

                        side:
                            BorderSide.none,

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(20),

                        ),

                      ),


                      icon: const Icon(

                        Icons.home_rounded,

                        color:
                            AppTheme.textDark,

                        size: 18,

                      ),


                      label: const Text(

                        'Back to Home',

                        style: TextStyle(

                          color:
                              AppTheme.textDark,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                    ),

                  ),



                  const SizedBox(width: 12),



                  Expanded(

                    child: OutlinedButton.icon(

                      onPressed: () {

                        Navigator.of(context)
                            .pushAndRemoveUntil(

                          MaterialPageRoute(
                            builder: (_) =>
                                const MainNavigationScreen(
                                  initialIndex: 1,
                                ),
                          ),

                          (route) => false,

                        );

                      },


                      style:
                          OutlinedButton.styleFrom(

                        backgroundColor:
                            Colors.grey.shade200,

                        side:
                            BorderSide.none,

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(20),

                        ),

                      ),


                      icon: const Icon(

                        Icons.history_rounded,

                        color:
                            AppTheme.textDark,

                        size: 18,

                      ),


                      label: const Text(

                        'View History',

                        style: TextStyle(

                          color:
                              AppTheme.textDark,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                    ),

                  ),

                ],

              ),


              const SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }



  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String val,
    required String subText,
    required double progress,
  }) {

    return Container(

      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(

        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(20),

      ),


      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,


        children: [

          Row(

            children: [

              Icon(
                icon,
                color:
                    iconColor,
                size: 20,
              ),


              const SizedBox(width: 8),


              Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 14,
                  color:
                      AppTheme.textMuted,
                ),
              ),

            ],

          ),


          const SizedBox(height: 8),


          Row(

            children: [

              Text(
                val,
                style:
                    const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppTheme.textDark,
                ),
              ),


              const SizedBox(width: 10),


              Text(
                subText,
                style:
                    const TextStyle(
                  fontSize: 13,
                  color:
                      AppTheme.textMuted,
                ),
              ),

            ],

          ),


          const SizedBox(height: 10),


          ClipRRect(

            borderRadius:
                BorderRadius.circular(4),

            child:
                LinearProgressIndicator(

              value:
                  progress,

              minHeight:
                  6,

              backgroundColor:
                  Colors.grey.shade100,

              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryTeal,
              ),

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildRecommendationItem({
    required String title,
    required String desc,
  }) {

    return Container(

      padding:
          const EdgeInsets.all(14),

      decoration:
          BoxDecoration(

        color:
            AppTheme.bgMint,

        borderRadius:
            BorderRadius.circular(16),

      ),


      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,


        children: [

          const Icon(

            Icons.check_circle_rounded,

            color:
                AppTheme.primaryTeal,

            size:
                20,

          ),


          const SizedBox(width: 10),


          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [

                Text(

                  title,

                  style:
                      const TextStyle(

                    fontWeight:
                        FontWeight.bold,

                    fontSize:
                        14,

                    color:
                        AppTheme.textDark,

                  ),

                ),


                const SizedBox(height: 2),


                Text(

                  desc,

                  style:
                      const TextStyle(

                    fontSize:
                        12.5,

                    color:
                        AppTheme.textMuted,

                    height:
                        1.3,

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }

}