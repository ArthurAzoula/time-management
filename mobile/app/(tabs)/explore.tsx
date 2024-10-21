import React from 'react';
import { StyleSheet, FlatList, View, SafeAreaView } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { useThemeColor } from '@/hooks/useThemeColor';
import { BarChart, LineChart } from 'react-native-chart-kit';
import { Dimensions } from 'react-native';

const screenWidth = Dimensions.get('window').width;

export default function DashboardScreen() {
  const backgroundColor = useThemeColor({}, 'background');
  const cardBackgroundColor = useThemeColor({}, 'background');
  const textColor = useThemeColor({}, 'text');
  const iconColor = useThemeColor({}, 'icon');

  const data = {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    datasets: [
      {
        data: [10, 45, 28, 80, 99, 43],
      },
    ],
  };

  const sections: Array<{ id: string; title: string; icon: 'time-outline' | 'checkmark-done-outline'; render: () => React.ReactNode }> = [
    {
      id: '1',
      title: 'Total Working Hours',
      icon: 'time-outline',
      render: () => (
        <LineChart
          data={data}
          width={screenWidth - 40} // from react-native
          height={220}
          chartConfig={{
            backgroundColor: cardBackgroundColor,
            backgroundGradientFrom: backgroundColor,
            backgroundGradientTo: cardBackgroundColor,
            decimalPlaces: 2,
            color: () => iconColor,
            labelColor: () => textColor,
          }}
          style={styles.chartStyle}
        />
      ),
    },
    {
      id: '2',
      title: 'Completed Tasks',
      icon: 'checkmark-done-outline',
      render: () => (
        <BarChart
          data={data}
          width={screenWidth - 40}
          height={220}
          yAxisLabel="$"
          yAxisSuffix="k"
          chartConfig={{
            backgroundColor: cardBackgroundColor,
            backgroundGradientFrom: backgroundColor,
            backgroundGradientTo: cardBackgroundColor,
            decimalPlaces: 2,
            color: () => iconColor,
            labelColor: () => textColor,
          }}
          style={styles.chartStyle}
        />
      ),
    },
  ];

  const renderItem = ({ item }: { item: { id: string; title: string; icon: 'time-outline' | 'checkmark-done-outline'; render: () => React.ReactNode } }) => (
    <View style={[styles.sectionCard, { backgroundColor: cardBackgroundColor }]}>
      <Ionicons name={item.icon} size={24} color={iconColor} style={styles.sectionIcon} />
      <View style={styles.sectionContent}>
        <ThemedText style={[styles.sectionTitle, { color: textColor }]}>{item.title}</ThemedText>
        {item.render()}
      </View>
    </View>
  );

  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor }]}>
      <ThemedView style={[styles.container, { backgroundColor }]}>
        <FlatList
          data={sections}
          renderItem={renderItem}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContainer}
        />
      </ThemedView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },
  container: {
    flex: 1,
    paddingHorizontal: 20,
    paddingVertical: 10,
  },
  listContainer: {
    paddingBottom: 20,
  },
  sectionCard: {
    flexDirection: 'column',
    padding: 15,
    borderRadius: 10,
    marginBottom: 15,
    shadowColor: '#000',
    shadowOpacity: 0.08,
    shadowOffset: { width: 0, height: 2 },
    shadowRadius: 8,
    elevation: 2,
  },
  sectionIcon: {
    alignSelf: 'center',
    marginBottom: 10,
  },
  sectionContent: {
    flex: 1,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 10,
    alignSelf: 'center',
  },
  chartStyle: {
    borderRadius: 10,
    alignSelf: 'center',
  },
});