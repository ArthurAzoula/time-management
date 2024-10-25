import React, { useState, useEffect } from 'react';
import { SafeAreaView, View, StyleSheet, FlatList, TouchableOpacity } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { Ionicons } from '@expo/vector-icons';
import { useThemeColor } from '@/hooks/useThemeColor';
import { HelloWave } from '@/components/HelloWave';
import { Link } from 'expo-router'; 
import { userService } from '@/services/userService';  // Import the user service for fetching user data
import { workingTimeService } from '@/services/workingTimeService';  // Import working time service for fetching times
import { WorkingTimeType } from '@/types/workingTimeType';
import { UserType } from '@/types/userType';

export default function HomeScreen() {
  const backgroundColor = useThemeColor({}, 'background');
  const cardBackgroundColor = useThemeColor({}, 'cardBackground');
  const textColor = useThemeColor({}, 'text');
  const buttonBackgroundColor = useThemeColor({}, 'iconBackground');
  const buttonTextColor = useThemeColor({}, 'buttonText');

  const [isClockedIn, setIsClockedIn] = useState<boolean>(false);
  const [elapsedTime, setElapsedTime] = useState<number>(0);
  const [username, setUsername] = useState<string>(''); // User's name
  const [workingTimes, setWorkingTimes] = useState<WorkingTimeType[] | null>([]); // Working times array
  const userId = 1;  // Example user ID to fetch data for

  // Fetch user and working times on mount
  useEffect(() => {
    const fetchUserData = async () => {
      try {
        const user: UserType = await userService.getUser(userId);  // Fetch user data
        setUsername(user.data.username);
      } catch (error) {
        console.error('Failed to fetch user data:', error);
      }
    };

    const fetchWorkingTimes = async () => {
      try {
        const response = await workingTimeService.getWorkingTimeByUserId(userId, {});
        const times = response;  // Access the correct data array
        setWorkingTimes(times.data);
      } catch (error) {
        console.error('Failed to fetch working times:', error);
      }
    };

    fetchUserData();
    fetchWorkingTimes();
  }, []);

  // Timer logic for clock in/out
  useEffect(() => {
    let timer: string | number | NodeJS.Timeout | undefined;
    if (isClockedIn) {
      timer = setInterval(() => {
        setElapsedTime((prevTime) => prevTime + 1);
      }, 1000);
    } else if (!isClockedIn && elapsedTime !== 0) {
      clearInterval(timer);
    }
    return () => clearInterval(timer);
  }, [isClockedIn]);

  const handleClockIn = () => {
    setIsClockedIn(true);
    setElapsedTime(0);
  };

  const handleClockOut = () => {
    setIsClockedIn(false);
  };

  const formatTime = (seconds: number) => {
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = seconds % 60;
    return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  };

  const renderWorkingTime = ({ item }: { item: WorkingTimeType }) =>  (
    <View style={[styles.workingTimeCard, { backgroundColor: cardBackgroundColor }]}>
      <ThemedText style={[styles.workingTimeText, { color: textColor }]}>
        {item.start} - {item.end}
      </ThemedText>
    </View>
  );

  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor }]}>
      <View style={styles.container}>
        
        {/* Welcome Section */}
        <View style={styles.welcomeContainer}>
          <ThemedText style={[styles.welcomeText, { color: textColor }]}>Welcome back, {username} ! <HelloWave /></ThemedText>
        </View>

        {/* Shortcuts (Dashboard and Profile) */}
        <View style={styles.shortcutContainer}>
          <Link href="/explore" asChild>
            <TouchableOpacity style={[styles.shortcutButton, { backgroundColor: buttonBackgroundColor }]}>
              <Ionicons name="stats-chart-outline" size={30} color={buttonTextColor} />
              <ThemedText style={[styles.shortcutButtonText, { color: buttonTextColor }]}>Statistics</ThemedText>
            </TouchableOpacity>
          </Link>
          <Link href="/profile" asChild>
            <TouchableOpacity style={[styles.shortcutButton, { backgroundColor: buttonBackgroundColor }]}>
              <Ionicons name="person-outline" size={30} color={buttonTextColor} />
              <ThemedText style={[styles.shortcutButtonText, { color: buttonTextColor }]}>Profile</ThemedText>
            </TouchableOpacity>
          </Link>
        </View>

        {/* Clock In/Out Button */}
        <TouchableOpacity
          onPress={isClockedIn ? handleClockOut : handleClockIn}
          style={[styles.clockButton, isClockedIn ? styles.clockOutButton : styles.clockInButton]}
        >
          <Ionicons name={isClockedIn ? "log-out-outline" : "log-in-outline"} size={30} color="#fff" />
          <ThemedText style={styles.clockButtonText}>{isClockedIn ? "Clock Out" : "Clock In"}</ThemedText>
          {isClockedIn && <ThemedText style={styles.timerText}>{formatTime(elapsedTime)}</ThemedText>}
        </TouchableOpacity>

        {/* Recent Working Times */}
        <View style={styles.workingTimesContainer}>
          <ThemedText style={[styles.sectionTitle, { color: textColor }]}>Recent Working Times</ThemedText>
          <FlatList
            data={workingTimes}  // Use the real working times data
            renderItem={renderWorkingTime}
            keyExtractor={(item) => item.id.toString()}
            style={styles.workingTimesList}
          />
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingBottom: 40,
  },
  welcomeContainer: {
    position: 'absolute',
    top: 50,
    alignItems: 'center',
    width: '100%',
    marginBottom: 30,
  },
  welcomeText: {
    fontSize: 20,
    fontWeight: '700',
    marginRight: 10,
    textAlign: 'center',
  },
  shortcutContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    width: '100%',
    marginBottom: 30,
  },
  shortcutButton: {
    flex: 1,
    marginHorizontal: 10,
    padding: 20,
    borderRadius: 15,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 3,
  },
  shortcutButtonText: {
    marginTop: 10,
    fontSize: 16,
    fontWeight: '700',
  },
  clockButton: {
    position: 'absolute',
    bottom: 20,
    width: '50%',
    paddingVertical: 20,
    borderRadius: 80,
    alignItems: 'center',
    justifyContent: 'center',
  },
  clockInButton: {
    backgroundColor: '#34D399',
  },
  clockOutButton: {
    backgroundColor: '#F87171',
  },
  clockButtonText: {
    marginTop: 10,
    fontSize: 18,
    fontWeight: '700',
    color: '#fff',
  },
  timerText: {
    marginTop: 5,
    fontSize: 16,
    color: '#fff',
  },
  workingTimesContainer: {
    width: '100%',
    marginTop: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 10,
    textAlign: 'center',
  },
  workingTimesList: {
    width: '100%',
  },
  workingTimeCard: {
    padding: 15,
    borderRadius: 10,
    elevation: 2,
    marginBottom: 10,
    alignItems: 'center',
  },
  workingTimeText: {
    fontSize: 16,
    fontWeight: '600',
  },
});