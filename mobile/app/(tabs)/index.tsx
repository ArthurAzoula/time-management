import React, { useState, useEffect } from 'react';
import { SafeAreaView, View, StyleSheet, FlatList, TouchableOpacity } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import { Ionicons } from '@expo/vector-icons';
import { useThemeColor } from '@/hooks/useThemeColor';
import { HelloWave } from '@/components/HelloWave';
import { Link } from 'expo-router'; // Import Link for navigation

export default function HomeScreen() {
  const backgroundColor = useThemeColor({}, 'background');
  const cardBackgroundColor = useThemeColor({}, 'cardBackground');
  const textColor = useThemeColor({}, 'text');
  const buttonBackgroundColor = useThemeColor({}, 'iconBackground');
  const buttonTextColor = useThemeColor({}, 'buttonText');

  const [isClockedIn, setIsClockedIn] = useState(false);
  const [elapsedTime, setElapsedTime] = useState(0);
  const username = "John"; // Placeholder username, replace with actual user data

  const fakeWorkingTimes = [
    { id: '1', date: '2024-10-22', duration: 3600 }, // 1 hour
    { id: '2', date: '2024-10-21', duration: 5400 }, // 1.5 hours
    { id: '3', date: '2024-10-20', duration: 7200 }, // 2 hours
    { id: '4', date: '2024-10-19', duration: 4500 }, // 1.25 hours
  ];

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

  const renderWorkingTime = ({ item }: { item: { id: string; date: string; duration: number } }) => (
    <View style={[styles.workingTimeCard, { backgroundColor: cardBackgroundColor }]}>
      <ThemedText style={[styles.workingTimeText, { color: textColor }]}>
        {item.date} - {formatTime(item.duration)}
      </ThemedText>
    </View>
  );

  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor }]}>
      <View style={styles.container}>
        
        {/* Welcome Section */}
        <View style={styles.welcomeContainer}>
          <ThemedText style={[styles.welcomeText, { color: textColor }]}>Welcome back, {username}! <HelloWave /></ThemedText>
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
            data={fakeWorkingTimes}
            renderItem={renderWorkingTime}
            keyExtractor={(item) => item.id}
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
    paddingBottom: 40, // Space for the Clock In button
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
    marginBottom: 30, // Space between shortcuts and Clock In button
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
    borderBlockColor: '#000',
    elevation : 2,
    marginBottom: 10,
    alignItems: 'center',
  },
  workingTimeText: {
    fontSize: 16,
    fontWeight: '600',
  },
});