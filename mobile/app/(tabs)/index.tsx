import React, { useState, useEffect } from 'react';
import { SafeAreaView, View, StyleSheet, TouchableOpacity } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { Ionicons } from '@expo/vector-icons';
import { useThemeColor } from '@/hooks/useThemeColor';
import { fetchUserData, fetchWorkingTimes, fetchClocks } from '@/utils/apiUtils';
import { handleClock } from '@/utils/clockUtils';
import { WorkingTimeType } from '@/types/workingTimeType';
import { UserType } from '@/types/userType';
import { HelloWave } from '@/components/HelloWave';
import { Link } from 'expo-router';
import WorkingTimeList from '@/components/WorkingTimeList';
import { format } from 'date-fns';

export default function HomeScreen() {
  const backgroundColor = useThemeColor({}, 'background');
  const cardBackgroundColor = useThemeColor({}, 'cardBackground');
  const textColor = useThemeColor({}, 'text');
  const buttonTextColor = useThemeColor({}, 'buttonText');

  const [isClockedIn, setIsClockedIn] = useState<boolean>(false);
  const [elapsedTime, setElapsedTime] = useState<number>(0);
  const [username, setUsername] = useState<string>(''); 
  const [workingTimes, setWorkingTimes] = useState<WorkingTimeType[] | null>([]); 
  const [clockMessage, setClockMessage] = useState<string>('');
  const userId = 1;

  useEffect(() => {
    const initializeData = async () => {
      try {
        const user: UserType = await fetchUserData(userId);
        setUsername(user.data.username);

        const workingTimes: WorkingTimeType[] = await fetchWorkingTimes(userId);
        setWorkingTimes(workingTimes);
      } catch (error) {
        console.error('Failed to initialize data:', error);
      }
    };

    initializeData();
  }, []);

  useEffect(() => {
    let timer: NodeJS.Timeout | undefined;
    if (isClockedIn) {
      timer = setInterval(() => {
        setElapsedTime((prevTime) => prevTime + 1);
      }, 1000);
    } else if (!isClockedIn && elapsedTime !== 0) {
      clearInterval(timer);
    }
    return () => clearInterval(timer);
  }, [isClockedIn]);

  const handleClockAction = async () => {
    await handleClock(userId);
    setIsClockedIn(!isClockedIn);
    setElapsedTime(0);
    updateClockMessage(); // Update the message after clocking in/out
  };

  const updateClockMessage = async () => {
    try {
      const clocks = await fetchClocks(userId);
      const lastClock = clocks[0];
  
      if (!lastClock) {
        setClockMessage('No clock-in record found');
        return;
      }
  
      const lastClockDate = new Date(lastClock.time);
  
      if (lastClock.status) {
        setClockMessage('You are currently working since ' + format(lastClockDate, 'hh:mm a'));
      } else {
        setClockMessage(`Last clocked out at: ${format(lastClockDate, 'hh:mm a')}`);
      }
    } catch (error) {
      console.error('Failed to update clock message:', error);
    }
  };
  
  useEffect(() => {
    updateClockMessage();
  }, [isClockedIn]);

  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor }]}>
      {/* Header */}
      <View style={styles.header}>
        <ThemedText style={[styles.greeting, { color: textColor }]}>
          Hello, {username}! <HelloWave/>
        </ThemedText>
      </View>

      <View style={styles.cardContainer}>
        <Link href="/explore" asChild style={styles.actionCard}>
          <TouchableOpacity>
            <Ionicons name="stats-chart-outline" size={30} color={buttonTextColor} />
            <ThemedText style={[styles.cardText, { color: buttonTextColor }]}>Statistics</ThemedText>
          </TouchableOpacity>
        </Link>

        <Link href="/profile" asChild style={styles.actionCard}>
          <TouchableOpacity >
            <Ionicons name="person-outline" size={30} color={buttonTextColor} />
            <ThemedText style={[styles.cardText, { color: buttonTextColor }]}>Profile</ThemedText>
          </TouchableOpacity>
        </Link>
      </View>

      {/* Working Times List */}
      {workingTimes && (
        <WorkingTimeList
          workingTimes={workingTimes}
          cardBackgroundColor={cardBackgroundColor}
          textColor={textColor}
        />
      )}

      {/* Clock In/Out Button */}
      <TouchableOpacity
        onPress={handleClockAction}
        style={[styles.fab, isClockedIn ? styles.clockOutButton : styles.clockInButton]}
      >
        <Ionicons name={isClockedIn ? "time" : "time-outline"} size={30} color="#fff" />
        {isClockedIn && <ThemedText style={styles.fabText}>{elapsedTime}</ThemedText>}
      </TouchableOpacity>

      {/* Display Clock Message */}
      <ThemedText style={styles.clockMessage}>{clockMessage}</ThemedText>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },
  header: {
    alignItems: 'center',
    marginVertical: 20,
  },
  greeting: {
    fontSize: 24,
    fontWeight: '700',
  },
  cardContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingHorizontal: 20,
    marginVertical: 20,
  },
  actionCard: {
    flex: 1,
    marginHorizontal: 10,
    paddingVertical: 25,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 5,
    shadowColor: '#000',
    shadowOffset: { width: 2, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 6,
    backgroundColor: '#4C51BF',
  },
  fullButtonLink: {
    width: '100%',
    alignItems: 'center',
  },
  cardText: {
    marginTop: 10,
    fontSize: 16,
    fontWeight: '700',
    letterSpacing: 0.5,
  },
  fab: {
    position: 'absolute',
    bottom: 30,
    right: 30,
    width: 60,
    height: 60,
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
    elevation: 5,
  },
  fabText: {
    fontSize: 12,
    color: '#fff',
    marginTop: 5,
  },
  clockInButton: {
    backgroundColor: '#34D399',
  },
  clockOutButton: {
    backgroundColor: '#F87171',
  },
  clockMessage: {
    textAlign: 'center',
    fontSize: 16,
    marginTop: 10,
    color: '#6B7280',
  }
});