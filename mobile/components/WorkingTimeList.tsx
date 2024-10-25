import React from 'react';
import { StyleSheet, View, FlatList } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { WorkingTimeType, WorkingTimeListProps } from '@/types/workingTimeType';

const WorkingTimeList: React.FC<WorkingTimeListProps> = ({ workingTimes, cardBackgroundColor, textColor }) => {
    const renderWorkingTime = ({ item }: { item: WorkingTimeType }) => (
      <View style={[styles.workingTimeCard, { backgroundColor: cardBackgroundColor }]}>
        <ThemedText style={[styles.workingTimeText, { color: textColor }]}>
          {new Date(item.start).toLocaleString()} - {new Date(item.end).toLocaleString()}
        </ThemedText>
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
      padding: 15,
      borderRadius: 15,
      marginVertical: 10,
      elevation: 3,
    },
    workingTimeText: {
      fontSize: 16,
    },
    sectionTitle: {
      fontSize: 20,
      fontWeight: '700',
      paddingHorizontal: 20,
      marginBottom: 10,
    },
  });

export default WorkingTimeList;