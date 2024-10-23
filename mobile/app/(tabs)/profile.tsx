import React, { useEffect, useState } from 'react';
import { StyleSheet, FlatList, View, Image, TouchableOpacity, SafeAreaView } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import { useThemeColor } from '@/hooks/useThemeColor';
import { userService } from '@/services/userService'; // Import the service
import { UserType } from '@/types/userType';

export default function ProfileScreen() {
  const backgroundColor = useThemeColor({}, 'background');
  const cardBackgroundColor = useThemeColor({}, 'background');
  const textColor = useThemeColor({}, 'text');
  const iconColor = useThemeColor({}, 'icon');

  const [user, setUser] = useState<UserType | null>(null);
  const userId = 1; // Example user ID to be fetched

  useEffect(() => {
    // Fetch user data on component mount
    const fetchUser = async () => {
      try {
        const data = await userService.getUser(userId);
        setUser(data); // Set the user data
      } catch (error) {
        console.error("Error fetching user data: ", error);
      }
    };

    fetchUser();
  }, []);

  const sections = [
    {
      id: '1',
      title: 'Account Settings',
      description: 'Manage your account and set e-mail preferences',
      icon: 'settings-outline' as const,
      action: () => console.log('Account Settings Pressed'),
    },
    {
      id: '2',
      title: 'Privacy',
      description: 'Review our privacy policy and manage your data',
      icon: 'lock-closed-outline' as const,
      action: () => console.log('Privacy Pressed'),
    },
    {
      id: '3',
      title: 'Notifications',
      description: 'Manage notification settings',
      icon: 'notifications-outline' as const,
      action: () => console.log('Notifications Pressed'),
    },
    {
      id: '4',
      title: 'Sign Out',
      description: 'Sign out of your account',
      icon: 'exit-outline' as const,
      action: () => console.log('Sign Out Pressed'),
    },
  ];

  const renderItem = ({ item }: { item: { id: string; title: string; description: string; icon: 'settings-outline' | 'lock-closed-outline' | 'notifications-outline' | 'exit-outline'; action: () => void; } }) => (
    <TouchableOpacity onPress={item.action}>
      <View style={[styles.sectionCard, { backgroundColor: cardBackgroundColor }]}>
        <Ionicons name={item.icon} size={24} color={iconColor} style={styles.sectionIcon} />
        <View style={styles.sectionContent}>
          <ThemedText style={[styles.sectionTitle, { color: textColor }]}>{item.title}</ThemedText>
          <ThemedText style={[styles.sectionDescription, { color: textColor }]}>{item.description}</ThemedText>
        </View>
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={[styles.safeArea, { backgroundColor }]}>
      <ThemedView style={[styles.container, { backgroundColor }]}>
        {user ? (
            console.log(user),
          <FlatList
            ListHeaderComponent={
              <View>
                {/* Profile Card */}
                <ThemedView style={[styles.profileCard, { backgroundColor: cardBackgroundColor }]}>
                  <Image
                    source={{ uri: 'https://randomuser.me/api/portraits/men/1.jpg' }}
                    style={styles.profileImage}
                  />
                  <View style={styles.profileDetails}>
                    <ThemedText style={[styles.profileName, { color: textColor }]}>{user.data.username}</ThemedText>
                    <ThemedText style={[styles.profileEmail, { color: textColor }]}>{user.data.email}</ThemedText>
                  </View>
                </ThemedView>
              </View>
            }
            data={sections}
            renderItem={renderItem}
            keyExtractor={(item) => item.id}
            contentContainerStyle={styles.listContainer}
          />
        ) : (
          <ThemedText style={[styles.loadingText, { color: textColor }]}>Loading...</ThemedText>
        )}
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
  profileCard: {
    borderRadius: 10,
    padding: 20,
    alignItems: 'center',
    elevation: 3,
    marginBottom: 20,
  },
  profileImage: {
    width: 100,
    height: 100,
    borderRadius: 50,
    marginBottom: 10,
  },
  profileDetails: {
    alignItems: 'center',
  },
  profileName: {
    fontSize: 22,
    fontWeight: 'bold',
  },
  profileEmail: {
    fontSize: 16,
    marginBottom: 10,
  },
  sectionCard: {
    flexDirection: 'row',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    elevation: 2,
    marginBottom: 15,
  },
  sectionIcon: {
    marginRight: 15,
  },
  sectionContent: {
    flex: 1,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
  },
  sectionDescription: {
    fontSize: 14,
    marginTop: 2,
  },
  loadingText: {
    textAlign: 'center',
    marginTop: 50,
  },
});