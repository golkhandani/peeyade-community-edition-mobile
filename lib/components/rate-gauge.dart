import 'package:flutter/material.dart';
import 'package:pyd/constants.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RateGauge extends StatelessWidget {
  RateGauge({Key? key, required this.color, required this.score})
      : super(key: key);

  final Color color;
  final double score;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kCardRateBoxHeight - 16,
      width: kCardRateBoxHeight - 16,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            axisLineStyle: AxisLineStyle(
                color: color.withOpacity(0.4),
                thickness: 0.2,
                thicknessUnit: GaugeSizeUnit.factor),
            startAngle: 270,
            endAngle: 270,
            minimum: 0,
            maximum: 5,
            showTicks: false,
            canScaleToFit: true,
            showLabels: false,
            ranges: <GaugeRange>[
              GaugeRange(
                startWidth: 4,
                endWidth: 4,
                startValue: 0,
                endValue: score,
                color: color,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.1,
                widget: Center(
                  child: Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
