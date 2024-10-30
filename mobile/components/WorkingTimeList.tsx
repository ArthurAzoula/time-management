import React from 'react';
import { StyleSheet, View, FlatList } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { WorkingTimeType, WorkingTimeListProps } from '@/types/workingTimeType';
import { Svg, Circle, Path } from 'react-native-svg';

const WorkingTimeList: React.FC<WorkingTimeListProps> = ({ workingTimes, cardBackgroundColor, textColor }) => {

  const renderWorkingTime = ({ item }: { item: WorkingTimeType }) => (
    <View style={styles.workingTimeCard}>
      <View style={styles.iconContainer}>
        <Svg height="24" width="24" viewBox="0 0 24 24">
          <Circle cx="12" cy="12" r="10" fill="#6c63ff" />
          <Path d="M12 6v6h4" stroke="#fff" strokeWidth="2" strokeLinecap="round" />
        </Svg>
      </View>
      <View style={styles.textContainer}>
        <ThemedText style={[styles.workingTimeText, { color: textColor }]}>
          {new Date(item.start).toLocaleString()} - {new Date(item.end).toLocaleString()}
        </ThemedText>
      </View>
    </View>
  );

  return (
    <FlatList
      data={workingTimes}
      renderItem={renderWorkingTime}
      keyExtractor={(item) => item.id.toString()}
      contentContainerStyle={styles.listContainer}
      ListHeaderComponent={
        <ThemedText style={[styles.sectionTitle, { color: textColor }]}>
          Recent Working Times
        </ThemedText>
      }
    />
  );
};

const styles = StyleSheet.create({
  listContainer: {
    paddingHorizontal: 20,
  },
  workingTimeCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 15,
    borderRadius: 20,
    marginVertical: 10,
    backgroundColor: 'linear-gradient(135deg, #6c63ff 0%, #c4b5fd 100%)', // Gradient background
    shadowColor: '#000',
    shadowOffset: { width: 10, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  iconContainer: {
    marginRight: 10,
  },
  textContainer: {
    flex: 1,
  },
  workingTimeText: {
    fontSize: 18,
    fontWeight: '600',
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '700',
    paddingHorizontal: 20,
    marginBottom: 20,
    color: '#4c51bf',
    textAlign: 'center',
  },
});

export default WorkingTimeList;
