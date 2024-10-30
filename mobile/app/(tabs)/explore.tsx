import React from 'react';
import { SafeAreaView, Dimensions, ScrollView, View, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import { LineChart, PieChart } from 'react-native-chart-kit';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { useThemeColor } from '@/hooks/useThemeColor';

const screenWidth = Dimensions.get('window').width;

export default function DashboardScreen() {
  const backgroundColor = useThemeColor({}, 'background');
  const cardBackgroundColor = useThemeColor({}, 'background');
  const textColor = useThemeColor({}, 'text');

  const dailyWorkData = {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    datasets: [
      {
        data: [6, 7, 5, 8, 7, 6, 4],
        color: () => '#C026D3',
      },
    ],
  };

  const workBreakData = [
    {
      name: 'Work Hours',
      population: 75,
      color: '#C026D3',
      legendFontColor: textColor,
      legendFontSize: 15,
    },
    {
      name: 'Break Hours',
      population: 25,
      color: '#FAE8FF',
      legendFontColor: textColor,
      legendFontSize: 15,
    },
  ];

  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor }]}>
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <View style={styles.dashboardContainer}>
          {/* Line Chart for Daily Work */}
          <ThemedView style={[styles.chartCard, { backgroundColor: cardBackgroundColor }]}>
            <ThemedText style={[styles.chartTitle, { color: textColor }]}>Weekly Work Hours</ThemedText>
            <LineChart
              data={dailyWorkData}
              width={screenWidth * 0.95}
              height={250}
              chartConfig={{
                backgroundGradientFrom: backgroundColor,
                backgroundGradientTo: cardBackgroundColor,
                color: () => '#C026D3',
                labelColor: () => textColor,
                decimalPlaces: 1,
                propsForBackgroundLines: {
                  strokeWidth: 0.5,
                  stroke: textColor,
                },
              }}
              style={styles.chartStyle}
              bezier
              withInnerLines={false}
            />
          </ThemedView>

          {/* Pie Chart for Work/Break Distribution */}
            <ThemedView style={[styles.pieCard, { backgroundColor: cardBackgroundColor }]}>
              <ThemedText style={[styles.chartTitle, { color: textColor }]}>Work vs. Break</ThemedText>
              <PieChart
                data={workBreakData}
                width={screenWidth * 0.9}
                height={240}
                chartConfig={{
                  backgroundColor: backgroundColor,
                  backgroundGradientFrom: backgroundColor,
                  backgroundGradientTo: cardBackgroundColor,
                  color: (opacity = 1) => `rgba(192, 38, 211, ${opacity})`,
                  labelColor: () => textColor,
                }}
                accessor={'population'}
                backgroundColor={'transparent'}
                paddingLeft={'15'}
                center={[0, 0]}
                hasLegend={true}
                absolute
              />
            </ThemedView>

          {/* Summary Section */}
          <ThemedView style={[styles.summaryCard, { backgroundColor: cardBackgroundColor }]}>
            <ThemedText style={[styles.summaryTitle, { color: textColor }]}>Today's Summary</ThemedText>
            <ThemedText style={[styles.summaryText, { color: textColor }]}>
              You have worked for <ThemedText style={styles.boldText}>6 hours</ThemedText> and taken
              <ThemedText style={styles.boldText}> 2 hours</ThemedText> of break today.
            </ThemedText>
          </ThemedView>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#F3F4F6',
  },
  scrollContainer: {
    paddingVertical: 20,
    alignItems: 'center',
  },
  dashboardContainer: {
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
  },
  chartCard: {
    marginVertical: 0,
    borderRadius: 20,
    padding: 20,
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },
  pieCard: {
    marginVertical: 0,
    borderRadius: 20,
    padding: 25,
    elevation: 3,
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },
  chartTitle: {
    fontSize: 20,
    fontWeight: '700',
    marginBottom: 10,
    textAlign: 'center',
  },
  chartStyle: {
    left: -22,
    marginTop: 10,
  },
  summaryCard: {
    marginVertical: 0,
    padding: 20,
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },
  summaryTitle: {
    fontSize: 20,
    fontWeight: '600',
    marginBottom: 10,
    textAlign: 'center',
  },
  summaryText: {
    fontSize: 17,
    textAlign: 'center',
  },
  boldText: {
    fontWeight: '700',
    color: '#C026D3',
  },
});