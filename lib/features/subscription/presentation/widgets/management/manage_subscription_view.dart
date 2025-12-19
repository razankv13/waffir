import 'package:flutter/material.dart';

import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class ManageSubscriptionView extends StatelessWidget {
  const ManageSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    // Using exact colors from Figma where they don't map perfectly to AppColors,
    // otherwise strictly using AppColors.
    const kColorPurple = AppColors.indigo;
    const kColorGreen01 = AppColors.waffirGreen01;
    const kColorGreen03 = AppColors.waffirGreen03;
    const kColorGreen04 = AppColors.waffirGreen04;
    const kColorBlack = AppColors.black;
    const kColorWhite = AppColors.white;
    const kColorGray01 = AppColors.gray01;
    const kColorGray04 = AppColors.gray04;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "My Subscription" Header
        SizedBox(
          width: responsive.scale(392),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'My Subscription',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: kColorBlack,
                  fontSize: responsive.scale(18),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Parkinsans', // Preserving font from Figma
                ),
              ),
              SizedBox(height: responsive.scale(16)),
            ],
          ),
        ),

        // Main Content Container
        Container(
          width: responsive.scale(392),
          padding: EdgeInsets.all(responsive.scale(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Savings Card
              _buildSavingsCard(responsive, kColorWhite, kColorBlack, kColorPurple),
              SizedBox(height: responsive.scale(24)),

              // Current Plan Card
              _buildCurrentPlanCard(responsive, kColorGreen01, kColorBlack, kColorWhite),
              SizedBox(height: responsive.scale(24)),

              // Family Members Section
              _buildFamilyMembersSection(responsive, kColorBlack, kColorGray01, kColorPurple, kColorWhite, kColorGreen03, kColorGreen04),
              SizedBox(height: responsive.scale(24)),

              // Manage Subscription Button (Cancel)
              _buildManageSubscriptionAction(responsive, kColorBlack, kColorWhite, kColorGreen04),
              SizedBox(height: responsive.scale(24)),

              // Help & Support
              _buildHelpAndSupport(responsive, kColorBlack, kColorGray04),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsCard(ResponsiveHelper responsive, Color bgColor, Color textColor, Color purpleColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.scale(18)),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Savings This Year',
                  style: TextStyle(
                    color: textColor,
                    fontSize: responsive.scale(18),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                SizedBox(height: responsive.scale(4)),
                Text(
                  "You've saved \$428 so far in 2023",
                  style: TextStyle(
                    color: textColor,
                    fontSize: responsive.scale(12),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.scale(12)),
          // Bars Graph
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(responsive, purpleColor, 32, '\$72'),
                _buildBar(responsive, purpleColor, 64, '\$156'),
                _buildBar(responsive, purpleColor, 48, '\$113'),
                _buildBar(responsive, purpleColor, 80, '\$187'),
              ],
            ),
          ),
          SizedBox(height: responsive.scale(8)),
          // Months Labels
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                _buildMonthLabel(responsive, 'Jan', textColor),
                const Spacer(),
                _buildMonthLabel(responsive, 'Feb', textColor),
                const Spacer(),
                _buildMonthLabel(responsive, 'Mar', textColor),
                const Spacer(),
                _buildMonthLabel(responsive, 'Apr', textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(ResponsiveHelper responsive, Color color, double height, String label) {
    return Container(
      width: responsive.scale(67),
      height: responsive.scale(height),
      decoration: BoxDecoration(color: color),
      child: Stack(
        children: [
          Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: responsive.scale(12),
                fontFamily: 'Parkinsans',
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthLabel(ResponsiveHelper responsive, String text, Color color) {
    return SizedBox(
      width: responsive.scale(67),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: responsive.scale(12),
          fontFamily: 'Parkinsans',
          fontWeight: FontWeight.w400,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard(ResponsiveHelper responsive, Color bgColor, Color textColor, Color whiteColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.scale(16)),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Plan',
            style: TextStyle(
              color: textColor,
              fontSize: responsive.scale(18),
              fontFamily: 'Parkinsans',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          SizedBox(height: responsive.scale(24)),
          Container(
            width: responsive.scale(325),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Family Annual Plan',
                  style: TextStyle(
                    color: textColor,
                    fontSize: responsive.scale(14),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: responsive.scale(8)),
                Text(
                  '\$79.99/year (33% off monthly)',
                  style: TextStyle(
                    color: textColor,
                    fontSize: responsive.scale(12),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                  ),
                ),
                 SizedBox(height: responsive.scale(8)),
                Text(
                  'Renews on Dec 15, 2023',
                  style: TextStyle(
                    color: textColor,
                    fontSize: responsive.scale(12),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                  ),
                ),
                 SizedBox(height: responsive.scale(8)),
                Text(
                  'Unlimited deals, Family sharing (up to 5)',
                  style: TextStyle(
                    color: textColor,
                    fontSize: responsive.scale(12),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.scale(24)),
          Container(
            height: responsive.scale(45),
            padding: EdgeInsets.symmetric(horizontal: responsive.scale(10), vertical: responsive.scale(2)),
            decoration: ShapeDecoration(
              color: whiteColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: textColor),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Center(
              child: Text(
                'Change Plan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: responsive.scale(16),
                  fontFamily: 'Parkinsans',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMembersSection(ResponsiveHelper responsive, Color blackColor, Color gray01Color, Color purpleColor, Color whiteColor, Color green03Color, Color green04Color) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: responsive.scale(360),
            child: Text(
              'Family Members',
              style: TextStyle(
                color: blackColor,
                fontSize: responsive.scale(17),
                fontFamily: 'Parkinsans',
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
          SizedBox(height: responsive.scale(12)),
          
          // Family Member 1 (You)
          _buildFamilyMemberItem(
            responsive, 
            initials: 'YS', 
            name: 'You (Sarah)', 
            role: 'Primary Account', 
            status: 'Active',
            statusColor: green03Color,
            bgColor: const Color(0xFFFFFCFC), // Gray-00 from Figma
            borderColor: gray01Color,
            avatarBgColor: purpleColor,
            avatarTextColor: whiteColor,
          ),
          
          SizedBox(height: responsive.scale(12)), // Stack overlap imitation if needed, but simple column is safer for now
          
          // Family Member 2 (Pending/Red) // Wait, Figma had a stacked layout with positioned elements.
          // Implementing as a list for simplicity unless stack visuals are critical.
          // Figma design had them stacked visually? No, just a list in a column.
          // Correct, the Figma code has Positioned(top: 76) which implies a stack.
          // Let's emulate the look with a Column for now as it's cleaner code.
          
           _buildFamilyMemberItem(
            responsive, 
            hasError: true,
            bgColor: gray01Color,
            borderColor: Colors.transparent, // Or similar
            avatarBgColor: AppColors.red,
            avatarTextColor: whiteColor,
             isSlot: false,
          ), 
          // Wait, the red one was empty in the Figma code? No, it had an empty child. Looks like a placeholder or error state.
          // Actually, looking at the code: "Container(width: 40, height: 40... color: Red... child: Stack())"
          // It seems to be a removed/error member. 
          // I will implement the next real members for now: "Emma Miller" and "Liam Miller".
          
           SizedBox(height: responsive.scale(12)),

          _buildFamilyMemberItem(
            responsive, 
            initials: 'EM', 
            name: 'Emma Miller', 
            role: 'Daughter', 
            status: 'Pending',
            statusColor: green03Color,
            bgColor: const Color(0xFFFFFCFC),
             borderColor: gray01Color,
            avatarBgColor: purpleColor,
            avatarTextColor: whiteColor,
            isPending: true,
          ),

           SizedBox(height: responsive.scale(12)),

          _buildFamilyMemberItem(
            responsive, 
            initials: 'LM', 
            name: 'Liam Miller', 
            role: 'Son', 
            status: 'Active',
            statusColor: green03Color,
            bgColor: const Color(0xFFFFFCFC),
             borderColor: gray01Color,
            avatarBgColor: purpleColor,
            avatarTextColor: whiteColor,
          ),
          
          SizedBox(height: responsive.scale(12)),

          // Add Member Button
          Container(
            width: double.infinity,
            height: responsive.scale(48),
            decoration: ShapeDecoration(
              color: green04Color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: whiteColor, size: responsive.scale(16)), // Placeholder icon
                SizedBox(width: responsive.scale(4)),
                Text(
                  'Add member',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: responsive.scale(14),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.scale(12)),
          
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '1',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: responsive.scale(12),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: ' slot remaining (max 5 members)',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: responsive.scale(12),
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberItem(
    ResponsiveHelper responsive, {
    String? initials,
    String? name,
    String? role,
    String? status,
    Color? statusColor,
    required Color bgColor,
    Color? borderColor,
    Color? avatarBgColor,
    Color? avatarTextColor,
    bool hasError = false,
    bool isPending = false,
    bool isSlot = true,
  }) {
    if (hasError) {
        // Reduced implementation for the red circle item
         return Container(
            width: responsive.scale(360),
            padding: EdgeInsets.fromLTRB(
              responsive.scale(12), 
              responsive.scale(12), 
              responsive.scale(16), 
              responsive.scale(12)
            ),
            decoration: ShapeDecoration(
              color: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(55),
              ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                     Container(
                        width: responsive.scale(40),
                        height: responsive.scale(40),
                        decoration: ShapeDecoration(
                            color: avatarBgColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                            ),
                        ),
                     )         
                ],
            ),
         );
    }
    
    return Container(
      width: responsive.scale(360),
      padding: EdgeInsets.fromLTRB(
        responsive.scale(12), 
        responsive.scale(12), 
        responsive.scale(24), 
        responsive.scale(12)
      ),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(55),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: responsive.scale(40),
                height: responsive.scale(40),
                decoration: ShapeDecoration(
                  color: avatarBgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Center(
                  child: Text(
                    initials ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: avatarTextColor,
                      fontSize: responsive.scale(12),
                      fontFamily: 'Parkinsans',
                      fontWeight: FontWeight.w500,
                      height: 1, // Adjusted height for centering
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.scale(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? '',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: responsive.scale(11.90),
                      fontFamily: 'Parkinsans',
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: responsive.scale(4)),
                  Text(
                    role ?? '',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: responsive.scale(10),
                      fontFamily: 'Parkinsans',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (status != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: responsive.scale(12), vertical: responsive.scale(8)),
              decoration: ShapeDecoration(
                color: isPending ? Colors.transparent : statusColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: isPending ? BorderSide(color: statusColor!, width: 1) : BorderSide.none,
                ),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isPending ? statusColor : Colors.white,
                  fontSize: responsive.scale(12),
                  fontFamily: 'Parkinsans',
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildManageSubscriptionAction(ResponsiveHelper responsive, Color blackColor, Color whiteColor, Color green04Color) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Subscription',
            style: TextStyle(
               color: blackColor,
               fontSize: responsive.scale(12),
               fontFamily: 'Parkinsans',
               fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsive.scale(16)),
          Container(
            width: double.infinity,
            height: responsive.scale(48),
            decoration: ShapeDecoration(
              color: whiteColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: green04Color),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Center(
              child: Text(
                'Cancel Subscription',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blackColor,
                  fontSize: responsive.scale(14),
                  fontFamily: 'Parkinsans',
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHelpAndSupport(ResponsiveHelper responsive, Color blackColor, Color gray04Color) {
      return SizedBox(
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                    'Help & Support',
                    style: TextStyle(
                        color: blackColor,
                        fontSize: responsive.scale(12),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                    ),
                ),
                SizedBox(height: responsive.scale(12)),
                _buildSupportItem(responsive, 'Contact Support', gray04Color),
                SizedBox(height: responsive.scale(4)),
                _buildSupportItem(responsive, 'FAQ & Troubleshooting', const Color(0xFF6E6B7F)),
                
                SizedBox(height: responsive.scale(64)),
                
                 Center(
                   child: Text(
                      'Terms of Service & Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: gray04Color,
                          fontSize: responsive.scale(10.20),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.57,
                      ),
                   ),
                 ),
            ],
        ),
      );
  }

  Widget _buildSupportItem(ResponsiveHelper responsive, String text, Color color) {
      return Row(
          children: [
              SizedBox(width: responsive.scale(20), height: responsive.scale(20)), // Placeholder for icon
              SizedBox(width: responsive.scale(4)),
              Text(
                 text,
                 style: TextStyle(
                     color: color,
                     fontSize: responsive.scale(11.90),
                     fontFamily: 'Inter',
                     fontWeight: FontWeight.w400,
                 ),
              ),
          ],
      );
  }
}
